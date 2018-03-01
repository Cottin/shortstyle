React = require 'react'
{div, a, br, textarea, pre, input, ul, li} = React.DOM
{} = require 'ramda' #auto_require:ramda

{createElementHelper} = require './utils'
_ = createElementHelper() # shorthand

Basic = require './Basic'
Fela = require './Fela'
BasicStr = require './BasicStr'

App = React.createClass
	render: ->
		_ {},
			_ Basic, {}
			_ Fela, {}
			_ BasicStr, {}

module.exports = App
