assert = require 'assert'
{prop, props, type} = require 'ramda' #auto_require:ramda
{} = require 'ramda-extras' #auto_require:ramda-extras
{deepEq, fdeepEq} = require 'testhelp' #auto_require:testhelp

shortstyle = require './shortstyle'
short = shortstyle()
short2 = shortstyle {}, {}, (x) ->
	if type(x) == 'Number' then x + 'rem'
	else x


describe 'shortstyle', ->
	describe 'as props', ->

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
				fdeepEq short({f: 't4bu2'})[1],
					fontFamily: 'Times New Roman, Times, serif'
					fontSize: '12px'
					fontWeight: 200
					color: 'rgba(0, 0, 100, 1)'

		describe 'bg = background', ->
			it 'simple cases', ->
				deepEq [{}, {backgroundColor: 'blue'}], short({bg: 'a1'})

		describe 'mix', ->
			it 'bg overwrites', ->
				fdeepEq short({bg: 'a1', mix: 'box'}), [{}, {
					backgroundColor: 'blue'
					boxShadow: '0 1px 2px 0 rgba(0,0,0,0.37)'
					borderRadius: 9
				}]

		describe 'edge cases', ->
			it 'undefined', ->
				deepEq [{}, {}], short()


	describe 'as string', ->

		describe 'h = height', ->
			it 'default unit', -> deepEq [{}, {height: '87px'}], short({s: 'h87'})
			it 'string', -> deepEq [{}, {height: '87%'}], short({s: 'h87%'})
			it 'custom unit', -> deepEq [{}, {height: '87rem'}], short2({s: 'h87'})

		describe 'w = width', ->
			it 'default unit', -> deepEq [{}, {width: '87px'}], short({s: 'w87'})

		describe 'm = margin', ->
			it 'default unit', -> deepEq [{}, {margin: '10px'}], short({s: 'm10'})
			it 'string', -> deepEq [{}, {margin: '10vh'}], short({s: 'm10vh'})
			it 'custom unit', -> deepEq [{}, {margin: '10rem'}], short2({s: 'm10'})

			it 'four', ->
				deepEq [{}, {margin: '0px 10px 2px 3px'}], short({s: 'm0_10_2_3'})
				deepEq [{}, {margin: '1px 10vh 2vw 3%'}], short({s: 'm1_10vh_2vw_3%'})
				deepEq [{}, {margin: '1rem 10vh 2vw 3%'}], short2({s: 'm1_10vh_2vw_3%'})

			it 'two', -> deepEq [{}, {margin: '1px 10vh'}], short({s: 'm1_10vh'})

		describe 'bg = background', ->
			it 'simple cases', ->
				deepEq [{}, {backgroundColor: 'blue'}], short({s: 'bga1'})

		describe 'f = font', ->
			it 'simple cases', ->
				fdeepEq short({s: 't4bu2'})[1],
					fontFamily: 'Times New Roman, Times, serif'
					fontSize: '12px'
					fontWeight: 200
					color: 'rgba(0, 0, 100, 1)'

		describe 'mix', ->
			it 'bg overwrites', ->
				fdeepEq short({s: 'bga1 _box'})[1],
					backgroundColor: 'blue'
					boxShadow: '0 1px 2px 0 rgba(0,0,0,0.37)'
					borderRadius: 9

			it 'mix in props overwrites s', ->
				fdeepEq short({s: '_box', mix: 'box2'})[1],
					backgroundColor: 'red'
					boxShadow: '1 1px 3px 0 rgba(0,0,0,0.37)'
					borderRadius: 29

		describe 'prio', ->
			it 's vs. props', ->
				fdeepEq short({s: 'bga1', bg: 'a2'})[1],
					backgroundColor: 'light-blue'

			it 'props vs. actual stype prop', ->
				fdeepEq short({bg: 'a2', style: {backgroundColor: 'teal'}})[1],
					backgroundColor: 'teal'






