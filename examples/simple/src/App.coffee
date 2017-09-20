React = require 'react'
{div, a, br, textarea, pre, input, ul, li} = React.DOM
{} = require 'ramda' #auto_require:ramda

{createElement} = require './utils'
_ = createElement # shorthand

Basic = require './Basic'
Fela = require './Fela'

App = React.createClass
	render: ->
		_ {},
			_ Basic, {}
			_ Fela, {}


module.exports = App
