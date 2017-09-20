{merge, props, type} = require 'ramda' #auto_require:ramda
React = require 'react'
shortstyle = require 'shortstyle'

styleMaps = require './styleMaps'
attrMaps = require './attrMaps'

calculateProps = shortstyle styleMaps, attrMaps

createElement = ->
	[a0]  = arguments

	if type(a0) == 'String'
		createElementString.apply undefined, arguments
	else if type(a0) == 'Object'
		createElementDiv.apply undefined, arguments
	else
		createElementComponent.apply undefined, arguments

createElementString = (s, props, children...) ->
	[props_, style] = calculateProps(props)
	React.createElement s, merge(props_, {style}), children...

createElementDiv = (props, children...) ->
	[props_, style] = calculateProps(props)
	React.createElement 'div', merge(props_, {style}), children...

createElementComponent = (component, props, children...) ->
	[props_, style] = calculateProps(props)
	React.createElement component, merge(props_, {style}), children...


createElementFela = (renderer) -> ->
	[a0]  = arguments

	if type(a0) == 'String'
		createElementString.apply undefined, arguments
	else if type(a0) == 'Object'
		createElementDivFela.apply renderer, arguments
	else
		createElementComponent.apply undefined, arguments

createElementDivFela = (props, children...) ->
	[props_, style] = calculateProps(props)
	className = @renderRule (-> style), {}
	React.createElement 'div', merge(props_, {className}), children...


module.exports = {createElement, createElementFela}
