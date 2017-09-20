{isNil, pair, props, test} = require 'ramda' #auto_require:ramda

baseStyleMaps = require './baseStyleMaps'

# o, o -> o -> [o, o]
# Supply your own styleMaps and attrMaps and get a transformation function back.
# Call that transformation function with properties for an element and get a
# pair back of [calculatedProperties, calculatedStyle]
shortstyle = (styleMaps = {}, attrMaps = {}) -> (props) ->
	style_ = Object.assign {}, props.style || {}
	props_ = {}

	for k,v of props
		if styleMaps[k]
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

	return [props_, style_]

module.exports = shortstyle


