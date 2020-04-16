{curry, fromPairs, head, identity, isNil, keys, last, map, match, max, merge, min, nth, replace, split, test, toPairs, trim, type} = R = require 'ramda' #auto_require: ramda
{$} = RE = require 'ramda-extras' #auto_require: ramda-extras
[] = [] #auto_sugar
qq = (f) -> console.log match(/return (.*);/, f.toString())[1], f()
qqq = (f) -> console.log match(/return (.*);/, f.toString())[1], JSON.stringify(f(), null, 2)
_ = (...xs) -> xs

getBaseStyleMaps = require './baseStyleMaps'

tryParseNum = (x) -> if isNaN x then x else Number(x)

_selectors =
	f: ':first-child'
	l: ':last-child' 
	e: ':nth-child(even)'
	o: ':nth-child(odd)'
	# https://css-tricks.com/solving-sticky-hover-states-with-media-hover-hover/
	ho: {'@media (hover: hover)': ':hover'}
	fo: ':focus'
	'2l': ':nth-last-child(2)'

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
# returns {a: {a1: 'x', a2: 'y}, b1: 'z'}
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
					Object.assign style, allStyleMaps[k](val)
				res[key] = style
			else throw new Error "NYI"
	return res


# Takes styleMaps and unit function and returns parse and createElementHelper
shortstyle = (styleMaps = {}, unit, selectors = {}) ->
	baseStyleMaps = getBaseStyleMaps unit
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


module.exports = shortstyle

