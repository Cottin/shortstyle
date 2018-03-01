{props, type} = require 'ramda' #auto_require:ramda
React = require 'react'
shortstyle = require 'shortstyle'

styleMaps = require './styleMaps'
attrMaps = require './attrMaps'


Shortstyle = shortstyle styleMaps, attrMaps, (x) ->
	if type(x) == 'Number' then x/10 + 'em'
	else x

createElementHelper = (felaRenderer) -> ->
	[comp, props, children] =
		Shortstyle.createElementHelper(felaRenderer)(arguments...)
	React.createElement comp, props, children...

module.exports = {createElementHelper}


