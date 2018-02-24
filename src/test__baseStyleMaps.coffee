assert = require 'assert'
{type} = require 'ramda' #auto_require:ramda
{} = require 'ramda-extras' #auto_require:ramda-extras
{deepEq, fdeepEq, ffit} = require 'testhelp' #auto_require:testhelp

shortstyle = require './shortstyle'
short = shortstyle()
short2 = shortstyle {}, {}, (x) ->
	if type(x) == 'Number' then x + 'rem'
	else x


describe 'shortstyle', ->

	describe 'h = height', ->
		it 'default unit', -> deepEq [{}, {height: '87px'}], short({h: 87})
		it 'string', -> deepEq [{}, {height: '87%'}], short({h: '87%'})
		it 'custom unit', -> deepEq [{}, {height: '87rem'}], short2({h: 87})

	describe 'm = margin', ->
		it 'default unit', -> deepEq [{}, {margin: '10px'}], short({m: 10})
		it 'string', -> deepEq [{}, {margin: '10vh'}], short({m: '10vh'})
		it 'custom unit', -> deepEq [{}, {margin: '10rem'}], short2({m: 10})

		it 'four', ->
			deepEq [{}, {margin: '0px 10px 2px 3px'}], short({m: '0 10 2 3'})
			deepEq [{}, {margin: '1px 10vh 2vw 3%'}], short({m: '1 10vh 2vw 3%'})
			deepEq [{}, {margin: '1rem 10vh 2vw 3%'}], short2({m: '1 10vh 2vw 3%'})

		it 'two', -> deepEq [{}, {margin: '1px 10vh'}], short({m: '1 10vh'})

	describe 'f = font', ->
		it 'simple cases', ->
			fdeepEq short({f: 145721})[1],
				fontFamily: 'Times New Roman, Times, serif'
				fontSize: '12px'
				fontWeight: 200
				color: 'rgba(0, 0, 100, 0.7)'
				textShadow: '1px 1px 1px rgba(0,0,0,0.50)'
			ffit short({f: 145700})[1],
				color: 'rgba(0, 0, 100, 0.7)'

	describe 'bg = background', ->
		it 'simple cases', ->
			deepEq [{}, {backgroundColor: 'blue'}], short({bg: 'a1'})

