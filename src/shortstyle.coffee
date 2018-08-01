{identity, isEmpty, isNil, join, keys, length, match, merge, props, reverse, sortBy, split, test, type} = require 'ramda' #auto_require:ramda
{fchange, cc} = require 'ramda-extras' #auto_require:ramda-extras

getBaseStyleMaps = require './baseStyleMaps'

tryParseNum = (x) -> if isNaN x then x else Number(x)

parseS = (keysByLength, allStyleMaps) -> (s) ->
	xs = split ' ', s
	props = {}
	mixins = []
	for x in xs
		if test /^_/, x
			mixins.push match(/^_(.*)/, x)[1]
			continue
		for k in keysByLength
			if test new RegExp("^#{k}"), x
				refine = allStyleMaps[k].refine || identity
				props[k] = cc tryParseNum, refine, match(new RegExp("^#{k}(.*)"), x)[1]
				break

	if ! isEmpty mixins then props.mix = join ' ', mixins

	return props


# o, o -> o -> [o, o]
# Supply your own styleMaps and attrMaps and get a transformation function back.
# Call that transformation function with properties for an element and get a
# pair back of [calculatedProperties, calculatedStyle]
shortstyle = (styleMaps = {}, attrMaps = {}, unit) ->

	baseStyleMaps = getBaseStyleMaps unit

	allStyleMaps = merge baseStyleMaps, styleMaps
	keysByLength = cc reverse, sortBy(length), keys, allStyleMaps

	parseS_ = parseS(keysByLength, allStyleMaps)

	calcProps = (props) ->
		style_ = {}
		props_ = {}

		propsWithS = merge parseS_(props?.s || ''), props
		delete propsWithS.s

		# give mix lower prio by doing it first
		if propsWithS.mix
			if styleMaps['mix']
				Object.assign style_, styleMaps['mix'](propsWithS.mix)

			else if baseStyleMaps['mix']
				Object.assign style_, baseStyleMaps['mix'](propsWithS.mix)

			delete propsWithS.mix


		for k,v of propsWithS
			if isNil v then continue

			else if styleMaps[k]
				if !isNil v then Object.assign style_, styleMaps[k](v)

			else if attrMaps[k]
				if !isNil v then Object.assign props_, attrMaps[k](v)

			else if baseStyleMaps[k]
				if !isNil v then Object.assign style_, baseStyleMaps[k](v)

			else if test /^\$/, k
				# escape if you want to use property that colides with the transformers
				# e.g. instead of MyComp {to: 1} which will fail, do MyComp {$to: 1}
				props_[k.substr(1)] = v

			else props_[k] = v

		return [props_, merge(style_, props.style || {})]

	createElementHelper = (felaRenderer) -> ->
		[a0]  = arguments

		if type(a0) == 'Object'
			comp = 'div'
			props = a0
			children = Array.prototype.splice.call(arguments, 1)
		else
			comp = a0 # either a string or a component, eg. 'span' or Icon
			props = arguments[1]
			children = Array.prototype.splice.call(arguments, 2)

		[props_, style_] = calcProps props

		props__ =
			if felaRenderer
				className_ = felaRenderer.renderRule (-> style_), {}
				fchange props_,
					className: (c) -> if c then c + ' ' + className_ else className_
			else
				fchange props_, style: (s) -> if s then merge style_, s else style_

		return [comp, props__, children]

	return {calcProps, createElementHelper}

module.exports = shortstyle


