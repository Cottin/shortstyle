React = require 'react'
{div, a, br, textarea, pre, input, ul, li} = React.DOM
{map, range} = require 'ramda' #auto_require:ramda

{createElementHelper} = require './utils'
_ = createElementHelper() # shorthand

Basic = React.createClass
	render: ->
		_ {s: 'xc_c w100vw h70vh ih1000 p20%_20% _blue fi____'},
			_ {s: 'tac fh9re4'}, 'USING STRINGS'
			_ {s: 'tac fh8wh4'}, 'Tired of the standard way of handing styling and 
			css-classes?'
			_ {s: 'h8%'}
			_ {s: 'tac fh6re3'}, 'Try something else instead!'
			_ {s: 'h2%'}
			_ {s: 'w10 h10 _lime', style: {width: 13}}
			_ {s: 'h2%'}
			_ {s: 'tac fv9gn6'}, 'ShortStyle'
			_ {s: 'h10%'}
			_ {s: 'xr__w'},
				map renderSquare, range(0,10)
			_ {s: '10%'}
			_ 'a', {href: 'https://github.com/Cottin/shortstyle', s: 'tac f_5bu6'},
				'https://github.com/Cottin/shortstyle'

renderSquare = (key) ->
	_ {key, s: '_square _lined p20 w10vw xw70 h10vw xh70 ccc h5wh4 m3vw'}, ':-)'

module.exports = Basic
