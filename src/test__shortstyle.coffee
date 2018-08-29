assert = require 'assert'
{__, empty, prop, props, type} = require 'ramda' #auto_require:ramda
{} = require 'ramda-extras' #auto_require:ramda-extras
{deepEq, fdeepEq} = require 'testhelp' #auto_require:testhelp

shortstyle = require './shortstyle'

{calcProps: short} = shortstyle()
{calcProps: short2} = shortstyle {}, {}, (x) ->
	if type(x) == 'Number' then x + 'rem'
	else x


describe 'shortstyle', ->

	describe 'as string', ->

		describe 'edge cases', ->
			it 'empty props', -> deepEq [{}, {}], short({})
			it 'undefined props', -> deepEq [{}, {}], short(undefined)

		describe 's_', ->
			it 'simple case', -> deepEq [{s: 'tac'}, {}], short({s_: 'tac'})

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

			it 'mt', -> deepEq [{}, {marginTop: '10vh'}], short({s: 'mt10vh'})
			it 'mb', -> deepEq [{}, {marginBottom: '10vh'}], short({s: 'mb10vh'})
			it 'ml', -> deepEq [{}, {marginLeft: '10vh'}], short({s: 'ml10vh'})
			it 'mr', -> deepEq [{}, {marginRight: '10vh'}], short({s: 'mr10vh'})

			it 'pt', -> deepEq [{}, {paddingTop: '10vh'}], short({s: 'pt10vh'})
			it 'pb', -> deepEq [{}, {paddingBottom: '10vh'}], short({s: 'pb10vh'})
			it 'pl', -> deepEq [{}, {paddingLeft: '10vh'}], short({s: 'pl10vh'})
			it 'pr', -> deepEq [{}, {paddingRight: '10vh'}], short({s: 'pr10vh'})

		describe 'wh = whitespace', ->
			it 'simple', -> deepEq [{}, {whiteSpace: 'nowrap'}], short({s: 'whn'})

		describe 'br = border-radius', ->
			it 'simple', -> deepEq [{}, {borderRadius: '87px'}], short({s: 'br87'})
			it 'four', ->
				deepEq [{}, {borderRadius: '0px 10px 2px 3px'}], short({s: 'br0_10_2_3'})

		describe 'xg = flexgrow', ->
			it 'simple', -> deepEq [{}, {flexGrow: 2}], short({s: 'xg2'})

		# describe 'bg = background', ->
		# 	it 'simple cases', ->
		# 		deepEq [{}, {backgroundColor: 'blue'}], short({s: 'bga1'})

		describe 'f = font', ->
			it 'simple cases', ->
				fdeepEq short({s: 'ft4bu2'})[1],
					fontFamily: 'Times New Roman, Times, serif'
					fontSize: '12px'
					fontWeight: 200
					color: 'rgba(0, 0, 100, 1)'

			describe '_', ->
				it 'familly', ->
					fdeepEq short({s: 'ft____'})[1],
						fontFamily: 'Times New Roman, Times, serif'

				it 'size', ->
					fdeepEq short({s: 'f_4___'})[1],
						fontSize: '12px'

				it 'color', ->
					fdeepEq short({s: 'f__lbu_'})[1],
						color: 'rgba(110, 200, 250, 1)'

				it 'weight', ->
					fdeepEq short({s: 'f____2'})[1],
					fontWeight: 200

				it 'size + weight', ->
					fdeepEq short({s: 'f_4__2'})[1],
					fontWeight: 200
					fontSize: '12px'

		describe 'mix', ->
			it 'order matters', ->
				fdeepEq short({s: '_box2 _box'})[1],
					backgroundColor: '#FEFFEF'
					boxShadow: '0 1px 2px 0 rgba(0,0,0,0.37)'
					borderRadius: 9

		describe 'prio', ->

			it 'props vs. actual stype prop', ->
				fdeepEq short({bg: 'a2', style: {backgroundColor: 'teal'}})[1],
					backgroundColor: 'teal'



	describe 'as prop', ->

		describe 'mix', ->
			it 'as prop', ->
				fdeepEq short({mix: 'box2 box'})[1],
					backgroundColor: '#FEFFEF'
					boxShadow: '0 1px 2px 0 rgba(0,0,0,0.37)'
					borderRadius: 9


