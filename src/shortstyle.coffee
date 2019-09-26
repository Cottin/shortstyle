{contains, fromPairs, identity, isNil, last, map, match, merge, nth, split, toPairs} = R = require 'ramda' #auto_require: ramda
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
	ho: ':hover'
	fo: ':focus'
	'2l': ':nth-last-child(2)'

selectors = $ _selectors, toPairs, map(([k, v]) -> ['n'+k, ":not(#{v})"]), fromPairs, merge _selectors


# Takes styleMaps and unit function and returns parse and createElementHelper
shortstyle = (styleMaps = {}, unit) ->
	baseStyleMaps = getBaseStyleMaps unit

	allStyleMaps = merge baseStyleMaps, styleMaps


	memo = {}

	return (str) ->
		if isNil str then return {}
		if memo[str] then return memo[str]
		
		style = {}
		ss = split ' ', str

		for s in ss
			if s == '' || s == 'false' || s == 'true' || s == 'undefined' || s == 'null' then continue

			if allStyleMaps[s[0] + s[1] + s[2] + s[3]] then k = s[0] + s[1] + s[2] + s[3]
			else if allStyleMaps[s[0] + s[1] + s[2]] then k = s[0] + s[1] + s[2]
			else if allStyleMaps[s[0] + s[1]] then k = s[0] + s[1]
			else if allStyleMaps[s[0]] then k = s[0]
			else if allStyleMaps[s] then k = s
			else
				console.warn "invalid shortstyle: #{s}"
				return {}

			v = s.substr k.length

			if contains ':', v
				[___, v2, sel] = match /^(.*):(.*)/, v
				selector = selectors[sel]
				if ! selector then console.warn "invalid selector: #{sel}"
				else
					style[selector] ?= {}
					val = $ v2, allStyleMaps[k].refine || identity, tryParseNum
					Object.assign style[selector], allStyleMaps[k](val)
			else
				val = $ v, allStyleMaps[k].refine || identity, tryParseNum
				Object.assign style, allStyleMaps[k](val)

		memo[str] = style

		return style


module.exports = shortstyle

