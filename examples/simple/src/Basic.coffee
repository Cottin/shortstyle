React = require 'react'
{div, a, br, textarea, pre, input, ul, li} = React.DOM
{map, range} = require 'ramda' #auto_require:ramda

{createElementHelper} = require './utils'
_ = createElementHelper() # shorthand

Basic = React.createClass
	render: ->
		_ {x: 'c_c', w: '100vw', h: '70vh', ih: 1000, p: '20% 20%', mix: 'blue', f: 'h4___'},
			_ {ta:'c', f: '_9re_'}, 'BASIC'
			_ {ta:'c', f: '_8wh_'}, 'Tired of the standard way of handing styling and 
			css-classes?'
			_ {h: '8%'}
			_ {ta:'c', f: '_6re3'}, 'Try something else instead!'
			_ {h: '2%'}
			_ {w: 10, h: 10, style: {width: 13}, mix: 'lime'}
			_ {h: '2%'}
			_ {ta:'c', f: 'v9gn6'}, 'ShortStyle'
			_ {h: 10}
			_ {x: 'r__w'},
				map renderSquare, range(0,10)
			_ {h: 10}
			_ 'a', {href: 'https://github.com/Cottin/shortstyle', ta:'c', f: 'i5bu6'},
				'https://github.com/Cottin/shortstyle'

renderSquare = (key) ->
	_ {key, mix: 'square lined', p: 20, w: '10vw', xw: 70, h: '10hw', xh: 70,
	x: 'ccc', f: 'h5wh4', m: '3vw'}, ':-)'

module.exports = Basic
