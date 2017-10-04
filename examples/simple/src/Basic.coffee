React = require 'react'
{div, a, br, textarea, pre, input, ul, li} = React.DOM
{map, range} = require 'ramda' #auto_require:ramda

{createElement} = require './utils'
_ = createElement # shorthand

Basic = React.createClass
	render: ->
		_ {x: 'c_c', ww: 100, hh: 70, ih: 1000, p: '20% 20%', bg: 'blue'},
			_ {ta:'c', f: 161040}, 'Tired of the standard way of handing styling and css-classes?'
			_ {hp: 8}
			_ {ta:'c', f: 152030}, 'Try something else instead!'
			_ {hp: 2}
			_ {ta:'c', f: 293060}, 'ShortStyle'
			_ {hp: 10}
			_ {x: 'r__w'},
				map renderSquare, range(0,10)
			_ {hp: 10}
			_ 'a', {href: 'https://github.com/Cottin/shortstyle', ta:'c', f: 352060},
				'https://github.com/Cottin/shortstyle'

renderSquare = (key) ->
	_ {key, bg: 'purple', ww: 10, xw: 70, hw: 10, xh: 70, x: 'ccc', f: 151040, m: '3vw'}, ':-)'

module.exports = Basic
