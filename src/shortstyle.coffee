{isEmpty, isNil, join, match, merge, props, replace, split, test} = require 'ramda' #auto_require:ramda

getBaseStyleMaps = require './baseStyleMaps'

tryParseNum = (x) -> if isNaN x then x else Number(x)

parseS = (s) ->
	xs = split ' ', s
	props = {}
	mixins = []
	for x in xs
		if test /^([a-z])(\d+)([a-z]{2,3})(\d)/, x then props.f = x
		else if test /^h/, x then props.h = tryParseNum match(/^h(.*)/, x)[1]
		else if test /^w/, x then props.w = tryParseNum match(/^w(.*)/, x)[1]
		else if test /^ih/, x then props.ih = tryParseNum match(/^ih(.*)/, x)[1]
		else if test /^xh/, x then props.xh = tryParseNum match(/^xh(.*)/, x)[1]
		else if test /^iw/, x then props.iw = tryParseNum match(/^iw(.*)/, x)[1]
		else if test /^xw/, x then props.xw = tryParseNum match(/^xw(.*)/, x)[1]

		else if test /^pos/, x then props.xw = match(/^pos(.*)/, x)[1]
		else if test /^lef/, x then props.lef = tryParseNum match(/^lef(.*)/, x)[1]
		else if test /^rig/, x then props.rig = tryParseNum match(/^rig(.*)/, x)[1]
		else if test /^top/, x then props.top = tryParseNum match(/^top(.*)/, x)[1]
		else if test /^bot/, x then props.bot = tryParseNum match(/^bot(.*)/, x)[1]

		else if test /^z/, x then props.z = tryParseNum match(/^z(.*)/, x)[1]
		else if test /^ta/, x then props.ta = match(/^ta(.*)/, x)[1]
		else if test /^wh/, x then props.wh = match(/^wh(.*)/, x)[1]
		else if test /^ov/, x then props.ov = match(/^ov(.*)/, x)[1]
		else if test /^tov/, x then props.tov = match(/^tov(.*)/, x)[1]

		else if test /^m/, x then props.m = replace /_/g, ' ', match(/^m(.*)/, x)[1]
		else if test /^p/, x then props.p = replace /_/g, ' ', match(/^p(.*)/, x)[1]

		else if test(/^r/, x) || test(/^c/, x) then props.x = x

		else if test /^bg/, x then props.bg = match(/^bg(.*)/, x)[1]
		else if test /^_/, x then mixins.push match(/^_(.*)/, x)[1]

	if ! isEmpty mixins then props.mix = join ' ', mixins

	return props


# o, o -> o -> [o, o]
# Supply your own styleMaps and attrMaps and get a transformation function back.
# Call that transformation function with properties for an element and get a
# pair back of [calculatedProperties, calculatedStyle]
shortstyle = (styleMaps = {}, attrMaps = {}, unit) -> (props) ->
	style_ = {}
	props_ = {}
	baseStyleMaps = getBaseStyleMaps unit

	propsWithS = merge parseS(props?.s || ''), props
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

	# existing style last since it has highest prio
	if props?.style then Object.assign style_, props.style

	return [props_, style_]

module.exports = shortstyle


