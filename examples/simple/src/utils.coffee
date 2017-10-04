{merge, none, props, type} = require 'ramda' #auto_require:ramda
React = require 'react'
shortstyle = require 'shortstyle'

styleMaps = require './styleMaps'
attrMaps = require './attrMaps'

_calculateProps = shortstyle styleMaps, attrMaps

# Runs supplied props through shortstyle and calls React.createElement
createElement = ->
	[a0]  = arguments

	if type(a0) == 'String'
		_createElementString.apply undefined, arguments
	else if type(a0) == 'Object'
		_createElementDiv.apply undefined, arguments
	else
		_createElementComponent.apply undefined, arguments

# Runs supplied props through shortstyle and runs the result through fela and
# lastly calls React.createElement
createElementFela = (renderer) -> ->
	[a0]  = arguments

	if type(a0) == 'String'
		_createElementString.apply undefined, arguments
	else if type(a0) == 'Object'
		_createElementDivFela.apply renderer, arguments
	else
		_createElementComponent.apply undefined, arguments



_createElementString = (s, props, children...) ->
	_[props_, style] = calculateProps(props)
	React.createElement s, merge(props_, {style}), children...

_createElementDiv = (props, children...) ->
	_[props_, style] = calculateProps(props)
	React.createElement 'div', merge(props_, {style}), children...

_createElementComponent = (component, props, children...) ->
	_[props_, style] = calculateProps(props)
	React.createElement component, merge(props_, {style}), children...

_createElementDivFela = (props, children...) ->
	_[props_, style] = calculateProps(props)
	className = @renderRule (-> style), {}
	React.createElement 'div', merge(props_, {className}), children...


#auto_export:none_
module.exports = {createElement, createElementFela}