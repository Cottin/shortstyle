React = require 'react'
{div, a, br, textarea, pre, input, ul, li} = React.DOM
{map, range} = require 'ramda' #auto_require:ramda
fela = require 'fela'
{Provider: FelaProvider} = require 'react-fela'

{createElementFela} = require './utils'

felaRenderer = fela.createRenderer()
_ = createElementFela(felaRenderer) # shorthand

felaMountNode = document.getElementById('stylesheet')

App = React.createClass
	render: ->
		_ {},
			_ FelaProvider, {renderer: felaRenderer, mountNode: felaMountNode},
				_ {f: 'c_c', ww: 100, hh: 70, ih: 1000, p: '20% 20%', bg: 'red'},
					_ {ta:'c', t: 161040}, 'Tired of the standard way of handing styling and css-classes?'
					_ {hp: 8}
					_ {ta:'c', t: 152030}, 'Try something else instead!'
					_ {hp: 2}
					_ {ta:'c', t: 293060}, 'ShortStyle'
					_ {hp: 10}
					_ {f: 'r__w'},
						map renderSquare, range(0,10)
					_ {hp: 10}
					_ 'a', {href: 'https://github.com/Cottin/shortstyle', ta:'c', t: 352060},
						'https://github.com/Cottin/shortstyle'

renderSquare = (key) ->
	_ {key, bg: 'purple', ww: 10, xw: 70, hw: 10, xh: 70, f: 'ccc', t: 151040, m: '3vw'}, ':-)'

module.exports = App
