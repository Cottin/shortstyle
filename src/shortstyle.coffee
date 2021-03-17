clamp = require('ramda/src/clamp'); curry = require('ramda/src/curry'); fromPairs = require('ramda/src/fromPairs'); head = require('ramda/src/head'); identity = require('ramda/src/identity'); isNil = require('ramda/src/isNil'); keys = require('ramda/src/keys'); last = require('ramda/src/last'); map = require('ramda/src/map'); match = require('ramda/src/match'); max = require('ramda/src/max'); merge = require('ramda/src/merge'); min = require('ramda/src/min'); nth = require('ramda/src/nth'); replace = require('ramda/src/replace'); split = require('ramda/src/split'); test = require('ramda/src/test'); toPairs = require('ramda/src/toPairs'); trim = require('ramda/src/trim'); type = require('ramda/src/type'); #auto_require: srcramda

{$, clamp} = require 'ramda-extras' #auto_require: ramda-extras
# $ = (data, functions...) -> pipe(functions...)(data)
[] = [] #auto_sugar
qq = (f) -> console.log match(/return (.*);/, f.toString())[1], f()
qqq = (...args) -> console.log ...args
_ = (...xs) -> xs

getBaseStyleMaps = require './baseStyleMaps'
colors = require './colors'

tryParseNum = (x) -> if isNaN x then x else Number(x)

_selectors =
	f: ':first-child'
	l: ':last-child' 
	e: ':nth-child(even)'
	o: ':nth-child(odd)'
	# https://css-tricks.com/solving-sticky-hover-states-with-media-hover-hover/
	# https://stackoverflow.com/questions/23885255/how-to-remove-ignore-hover-css-style-on-touch-devices
	ho: {'@media (hover: hover)': ':hover'}
	fo: ':focus'
	'2l': ':nth-last-child(2)'
	fin: {'@media (pointer: fine)': ''}
	coa: {'@media (pointer: coarse)': ''}
	ac: ':active'

baseSelectors = $ _selectors, toPairs, map(([k, v]) -> ['n'+k, ":not(#{v})"]), fromPairs, merge _selectors
baseSelectors.hofo = [{'@media (hover: hover)': ':hover'}, ':focus']

# R.match(/(\w)(\d)/g, 'a1 b2 c3') returns ["a1", "b2", "c3"]
# matchG(/(\w)(\d)/g, 'a1 b2 c3') returns [["a1", "a", "1"], ["b2", "b", "2"], ["c3", "c", "3"]]
# ie. matchG includes the capturing groups for each match which R.match does not do when g-flag is used
# similar to how m.forEach((match, groupIndex) => ..) works with regex.exec in "raw" javascript, eg:
# Ex. https://regex101.com/r/CjwqtE/1
# https://regex101.com/r/CjwqtE/1/codegen?language=javascript
# https://ramdajs.com/repl/?v=0.26.1#?R.match%28%2F%28%5Cw%29%28%5Cd%29%2Fg%2C%20%27a1%20b2%20c3%27%29
matchG = curry (re, str) ->
	res = []
	reG = new RegExp re.source, re.flags + test(/g/, re.flags) && '' || 'g'
	while (m = reG.exec(str)) != null
		# This is necessary to avoid infinite loops with zero-width matches
		if m.index == reG.lastIndex
			reG.lastIndex++
		# The result can be accessed through the `m`-variable.
		lastGroupIndex = 999
		m.forEach (match, groupIndex) ->
			if groupIndex < lastGroupIndex then res.push []
			res[res.length-1].push match
			lastGroupIndex = groupIndex

	return res

# eg. '<100[m1] p2' => {'': 'p2', '@media (max-width: 100px)': 'm1'}
extractMediaQueries = (str) ->
	REmedia	= /([<>])(\d+)\[(.*?)\]\s?/g
	ms = matchG REmedia, str
	media = {}
	for m in ms
		[___, gt_lt, size, body] = m
		media["@media (#{gt_lt == '<' && 'max' || 'min'}-width: #{size}px)"] = body

	media[''] = $ str, replace(REmedia, ''), trim
	return media

# Recursively flattens values for the empty key ''
# eg. {a: {'': {a1: 'x'}, a2: 'y'}, '': {b1: 'z'}}
# returns {a: {a1: 'x', a2: 'y'}, b1: 'z'}
untangle = (o) ->
	if type(o) != 'Object' then return o
	res = {}
	for k, v of o
		if k == '' then Object.assign res, untangle(v)
		else res[k] = untangle(v)
	return res

# Unpure helper that sets or merges value x onto o[k]
setOrAppend = (k, x, o) ->
	if !o[k] then o[k] = x
	else
		if type(x) == 'String' then o[k] += ' ' + x
		else if type(x) == 'Object' then o[k] = merge o[k], x

addSelectors = (allSelectors, o) ->
	REsels = /(\w+)\((.*?)\)\s?/g
	res = {}
	for k, v of o
		if type(v) != 'String' then throw new Error 'NYI' # could easily support more nesting of @medias though
		ms = matchG REsels, v
		res[k] = {'': $ v, replace(REsels, ''), trim}
		for m in ms
			[___, sel, body] = m
			selector = allSelectors[sel]
			if !selector then console.warn "invalid selector: #{sel}"
			else if type(selector) == 'Array'
				for x in selector
					if type(x) == 'String' then setOrAppend x, body, res[k]
					else if type(x) == 'Object'
						media = $ x, keys, head
						setOrAppend media, {"#{x[media]}": body}, res[k]
					else throw new Error 'NYI'
			else if type(selector) == 'Object'
				media = $ selector, keys, head
				setOrAppend media, {"#{selector[media]}": body}, res[k]
			else if type(selector) == 'String'
				setOrAppend selector, body, res[k]
			else throw new Error "NYI selector type #{type(selector)}"

	return res

addStyle = (allStyleMaps, o) ->
	res = {}
	for key, v of o
		switch type v
			when 'Object' then res[key] = addStyle allStyleMaps, v
			when 'String'
				ss = split ' ', v
				style = {}
				for s in ss
					if s == '' || s == 'false' || s == 'true' || s == 'undefined' || s == 'null' then continue

					for i in [s.length...0]
						si = s.substr 0, i
						if allStyleMaps[si]
							k = si
							break

					if !k
						console.warn "invalid shortstyle: #{s}"
						res[key] = {}
						continue

					v = s.substr k.length # eg. top5 -> 5

					val = $ v, allStyleMaps[k].refine || identity, tryParseNum
					Object.assign style, allStyleMaps[k](val, style)
				res[key] = style
			else throw new Error "NYI"
	return res

	
# https://regex101.com/r/0RVVBU/1
RE_UNIT = ///
(-)?(\d+)(vh|vw|%|px|vmin|vmax)? # num + unit, eg. 30vw 
(?:\+(\d+)(vh|vw|%|px|vmin|vmax))? # extra + extraUnit, eg. 8+4vw
(?:<(\d+)(vh|vw|%|px|vmin|vmax)?)? # min + minUnit, eg. 8vw<10rem
(?:>(\d+)(vh|vw|%|px|vmin|vmax)?)? # max + maxUnit, eg. 8vw>20rem
///


defaultUnit = (x, base = 0) ->
	if type(x) == 'Number'
		return (x + base) / 10 + 'rem'
	else if ! isNaN(x) # we allow numbers as strings to eg. '2' so we can be a bit lazy in parsing
		x_ = parseFloat(x)
		return (x_ + base) / 10 + 'rem'
	else
		if test RE_UNIT, x
			[___, neg, num_, unit, extraNum_, extraUnit, minNum_, minUnit, maxNum_, maxUnit] = match RE_UNIT, x
			if unit then num = num_
			else num = parseInt(num_) / 10 + base
			if extraNum_
				if extraUnit then extraNum = extraNum_
				else extraNum = parseInt(extraNum_) / 10 + base
			if minNum_
				if minUnit then minNum = minNum_
				else minNum = parseInt(minNum_) / 10 + base
			if maxNum_
				if maxUnit then maxNum = maxNum_
				else maxNum = parseInt(maxNum_) / 10 + base

			neg = if neg then '-' else ''
			unit ?= 'rem'
			minUnit ?= 'rem'
			maxUnit ?= 'rem'

			if !extraNum then expr = "#{neg}#{num}#{unit}"
			else
				if neg then expr = "calc(#{neg}(#{num}#{unit}+#{extraNum}#{extraUnit}))"
				else expr = "calc(#{neg}#{num}#{unit}+#{extraNum}#{extraUnit})"

			if minNum && maxNum then return "clamp(#{minNum}#{minUnit}, #{expr}, #{maxNum}#{maxUnit})"
			else if minNum then return "min(#{minNum}#{minUnit}, #{expr})"
			else if maxNum then return "max(#{expr}, #{maxNum}#{maxUnit})"
			else return expr
		else
			return x

defaultColors = colors.buildColors
	wh: [0, 0, 100]
	bk: [0, 0, 0]
	gn: [177, 51, 35]
	ye: [52, 58, 99]




# Takes styleMaps and unit function and returns parse and createElementHelper
shortstyle = ({styleMaps = {}, unit = defaultUnit, colors = defaultColors, selectors = {}}) ->
	baseStyleMaps = getBaseStyleMaps unit, colors
	allStyleMaps = merge baseStyleMaps, styleMaps
	allSelectors = merge baseSelectors, selectors
	memo = {}

	return (str) ->
		if isNil str then return {}
		if memo[str] then return memo[str]

		# 'm2 <200[m1 f(p2)]'
		style1 = extractMediaQueries str
		# {'': 'm2', '@media (min-width: 200px)': 'm1 f(p2)'}
		style2 = addSelectors allSelectors, style1
		# {'': {'': 'm2'}, '@media (min-width: 200px)': {'': 'm1', ':first-child': 'p2'}}
		style3 = addStyle allStyleMaps, style2
		# {'': {'': {margin: 2}}, '@media (min-width: 200px)': {'': {margin: 1}, ':first-child': {padding: 2}}}
		style4 = untangle style3
		# {margin: 2, '@media (min-width: 200px)': {margin: 1, ':first-child': {padding: 2}}}

		memo[str] = style4
		return style4

shortstyle.colors = colors
shortstyle.defaultUnit = defaultUnit

module.exports = shortstyle

