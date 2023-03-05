import clamp from "ramda/es/clamp"; import clone from "ramda/es/clone"; import curry from "ramda/es/curry"; import filter from "ramda/es/filter"; import identity from "ramda/es/identity"; import isNil from "ramda/es/isNil"; import last from "ramda/es/last"; import map from "ramda/es/map"; import match from "ramda/es/match"; import max from "ramda/es/max"; import mergeRight from "ramda/es/mergeRight"; import mergeWith from "ramda/es/mergeWith"; import min from "ramda/es/min"; import nth from "ramda/es/nth"; import replace from "ramda/es/replace"; import split from "ramda/es/split"; import test from "ramda/es/test"; import trim from "ramda/es/trim"; import type from "ramda/es/type"; #auto_require: esramda
import {$, sf0} from "ramda-extras" #auto_require: esramda-extras

import getBaseStyleMaps from './baseStyleMaps'
import * as colors from './colors'

tryParseNum = (x) -> if isNaN x then x else Number(x)

baseSelectors = {}
baseSelectors.f = (body) -> {':first-child': body}
baseSelectors.fc1 = (body) -> {':first-child': {'& .c1': body}}
baseSelectors.fc2 = (body) -> {':first-child': {'& .c2': body}}
baseSelectors.fc3 = (body) -> {':first-child': {'& .c3': body}}
baseSelectors.fc4 = (body) -> {':first-child': {'& .c4': body}}
baseSelectors.fc5 = (body) -> {':first-child': {'& .c5': body}}

baseSelectors.l = (body) -> {':last-child': body}
baseSelectors.lc1 = (body) -> {':last-child': {'& .c1': body}}
baseSelectors.lc2 = (body) -> {':last-child': {'& .c2': body}}
baseSelectors.lc3 = (body) -> {':last-child': {'& .c3': body}}
baseSelectors.lc4 = (body) -> {':last-child': {'& .c4': body}}
baseSelectors.lc5 = (body) -> {':last-child': {'& .c5': body}}

baseSelectors.e = (body) -> {':nth-child(even)': body}
baseSelectors.o = (body) -> {':nth-child(odd)': body}
# https://css-tricks.com/solving-sticky-hover-states-with-media-hover-hover/
# https://stackoverflow.com/questions/23885255/how-to-remove-ignore-hover-css-style-on-touch-devices
baseSelectors.ho = (body) -> {'@media (hover: hover)': {':hover': body}}
baseSelectors.fo = (body) -> {':focus': body}
baseSelectors['2l'] = (body) -> {':nth-last-child(2)': body}
baseSelectors.fin = (body) -> {'@media (pointer: fine)': body}
baseSelectors.coa = (body) -> {'@media (pointer: coarse)': body}
baseSelectors.ac = (body) -> {':active': body}

baseSelectors.nf = (body) -> {':not(:first-child)': body}
baseSelectors.nfc1 = (body) -> {':not(:first-child)': {'& .c1': body}}
baseSelectors.nfc2 = (body) -> {':not(:first-child)': {'& .c2': body}}
baseSelectors.nfc3 = (body) -> {':not(:first-child)': {'& .c3': body}}
baseSelectors.nfc4 = (body) -> {':not(:first-child)': {'& .c4': body}}
baseSelectors.nfc5 = (body) -> {':not(:first-child)': {'& .c5': body}}

baseSelectors.nl = (body) -> {':not(:last-child)': body}
baseSelectors.nlc1 = (body) -> {':not(:last-child)': {'& .c1': body}}
baseSelectors.nlc2 = (body) -> {':not(:last-child)': {'& .c2': body}}
baseSelectors.nlc3 = (body) -> {':not(:last-child)': {'& .c3': body}}
baseSelectors.nlc4 = (body) -> {':not(:last-child)': {'& .c4': body}}
baseSelectors.nlc5 = (body) -> {':not(:last-child)': {'& .c5': body}}

baseSelectors.nac = (body) -> {':not(:active)': body}

baseSelectors.hofo = (body) -> {'@media (hover: hover)': {':hover': body}, ':focus': body}

# selectors for hover and focus that targets children
baseSelectors.hoc1 = (body) -> {'@media (hover: hover)': {':hover': {'& .c1': body}}}
baseSelectors.hoc2 = (body) -> {'@media (hover: hover)': {':hover': {'& .c2': body}}}
baseSelectors.hoc3 = (body) -> {'@media (hover: hover)': {':hover': {'& .c3': body}}}
baseSelectors.hoc4 = (body) -> {'@media (hover: hover)': {':hover': {'& .c4': body}}}
baseSelectors.hoc5 = (body) -> {'@media (hover: hover)': {':hover': {'& .c5': body}}}

# if we are already using hoc1 setting ho on child has too low specificity, this is a workaround
baseSelectors.hoc1ho = (body) -> {'@media (hover: hover)': {':hover': {'& .c1:hover': body}}}
baseSelectors.hoc2ho = (body) -> {'@media (hover: hover)': {':hover': {'& .c2:hover': body}}}
baseSelectors.hoc3ho = (body) -> {'@media (hover: hover)': {':hover': {'& .c3:hover': body}}}
baseSelectors.hoc4ho = (body) -> {'@media (hover: hover)': {':hover': {'& .c4:hover': body}}}
baseSelectors.hoc5ho = (body) -> {'@media (hover: hover)': {':hover': {'& .c5:hover': body}}}

baseSelectors.foc1 = (body) -> {':focus': {'& .c1': body}}
baseSelectors.foc2 = (body) -> {':focus': {'& .c2': body}}
baseSelectors.foc3 = (body) -> {':focus': {'& .c3': body}}
baseSelectors.foc4 = (body) -> {':focus': {'& .c4': body}}
baseSelectors.foc5 = (body) -> {':focus': {'& .c5': body}}

baseSelectors.hofoc1 = (body) -> {'@media (hover: hover)': {':hover': {'& .c1': body}}, ':focus': {'& .c1': body}}
baseSelectors.hofoc2 = (body) -> {'@media (hover: hover)': {':hover': {'& .c2': body}}, ':focus': {'& .c2': body}}
baseSelectors.hofoc3 = (body) -> {'@media (hover: hover)': {':hover': {'& .c3': body}}, ':focus': {'& .c3': body}}
baseSelectors.hofoc4 = (body) -> {'@media (hover: hover)': {':hover': {'& .c4': body}}, ':focus': {'& .c4': body}}
baseSelectors.hofoc5 = (body) -> {'@media (hover: hover)': {':hover': {'& .c5': body}}, ':focus': {'& .c5': body}}

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
		else if type(x) == 'Object' then o[k] = mergeRight o[k], x

# Helper for merging that handles strings and empty objects '': {}
mergeNice = mergeWith (a, b) ->
	if type(a) == 'String'
		if type(b) == 'String' then b + ' ' + a
		else mergeNice {'': a}, b
	else if type(a) == 'Object'
		if type(b) == 'Object' then mergeNice a, b
		else mergeNice a, {'': b}
	else throw new Error 'NYI'

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
			if !selector
				console.warn "invalid selector: #{sel}"
				return res
			content = selector body
			res[k] = mergeNice content, res[k]

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
					k = undefined # need to reset otherwise k from last lap in loop is used
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
			else
				throw new Error "NYI addStyle for: #{sf0 v} (#{type v})"
	return res


# https://regex101.com/r/0RVVBU/1
RE_UNIT = ///
(-)?(\d+(?:\.\d+)?)(vh|vw|%|px|vmin|vmax)? # num + unit, eg. 33.3%
(?:\+(\d+(?:\.\d+)?)(vh|vw|%|px|vmin|vmax))? # extra + extraUnit, eg. 8+4.5vw
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
				if neg then expr = "calc(-1 * (#{num}#{unit} + #{extraNum}#{extraUnit}))"
				else expr = "calc(#{neg}#{num}#{unit} + #{extraNum}#{extraUnit})"

			if minNum && maxNum then return "clamp(#{maxNum}#{maxUnit}, #{expr}, #{minNum}#{minUnit})"
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

defaultFamilies = ['Arial, sans', 'Times New Roman, Times, serif']

# Pre-executes styleMaps defined as strings and returns allStyleMaps
# eg. {_myStyle1: () -> backgroundColor: 'lime', _myStyle2: 'p2 _myStyle1'}
#   returns {..., _myStyle2: () -> backgroundColor: 'lime', padding: 2}
prepareAllStyleMaps = (baseStyleMaps, styleMaps, allSelectors) ->
	styleMapsF = $ styleMaps, filter (x) -> 'Function' == type x
	styleMapsS = $ styleMaps, filter (x) -> 'String' == type x
	simpleStyleMaps = mergeRight baseStyleMaps, styleMapsF

	styleMapsSasF = $ styleMapsS, map (str) ->
		# copy paste from below
		style1 = extractMediaQueries str
		style2 = addSelectors allSelectors, style1
		style3 = addStyle simpleStyleMaps, style2
		style4 = untangle style3

		return () -> style4

	return mergeRight simpleStyleMaps, styleMapsSasF

handleESModule = (o) ->
	if o.__esModule || o[Symbol.toStringTag] == 'Module'
		cleanO = {}
		for k, v of o then cleanO[k] = v
		return cleanO
	else o

# Takes styleMaps and unit function and returns parse and createElementHelper
export default shortstyle = ({styleMaps = {}, unit = defaultUnit, colors = defaultColors, families = defaultFamilies, selectors = {}}) ->
	styleMapsObj = handleESModule styleMaps
	baseStyleMaps = getBaseStyleMaps unit, colors, families
	allSelectors = mergeRight baseSelectors, selectors
	allStyleMaps = prepareAllStyleMaps baseStyleMaps, clone(styleMapsObj), allSelectors
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


