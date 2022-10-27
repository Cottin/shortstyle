{__, clamp, empty, last, match, max, min, none, props, test, type} = R = require 'ramda' #auto_require: ramda
{clamp} = RE = require 'ramda-extras' #auto_require: ramda-extras
[ːlast] = ['last'] #auto_sugar
qq = (f) -> console.log match(/return (.*);/, f.toString())[1], f()
qqq = (...args) -> console.log ...args
_ = (...xs) -> xs
assert = require 'assert'
{eq, deepEq, fdeepEq} = require 'testhelp' #auto_require: testhelp

shortstyle = require './shortstyle'

styleMaps =
	_box0: 'p2 _box2'

	_box: ->
		backgroundColor: '#FEFFEF'
		boxShadow: '0 1px 2px 0 rgba(0,0,0,0.37)'
		borderRadius: 9

	_box2: ->
		backgroundColor: 'red'
		boxShadow: '1 1px 3px 0 rgba(0,0,0,0.37)'
		borderRadius: 29

colors = shortstyle.colors.buildColors
	wh: _ 0, 0, 100
	bk: _ 0, 0, 0
	re: _ 11, 95, 43
	bu: _ 206, 34, 52 # 88, 113, 133 # 2 brighter: 121, 157, 184 # 2 darker 54, 70, 82

families = ['Arial, sans-serif', 'Times New Roman, Times, serif']

unit = (x) ->
	if type(x) == 'Number' || ! isNaN(x) then x + 'px'
	else x

short = shortstyle {styleMaps, colors, families, unit}
short2 = shortstyle {styleMaps: {}}

describe 'shortstyle', ->
	describe 'default unit', ->
		it '1', -> eq '0.4rem', shortstyle.defaultUnit '4'
		it '1.1', -> eq '33.3%', shortstyle.defaultUnit '33.3%'
		it '2', -> eq '-0.4rem', shortstyle.defaultUnit '-4'
		it '3', -> eq '4vw', shortstyle.defaultUnit '4vw'
		it '4', -> eq '4vh', shortstyle.defaultUnit '4vh'
		it '5', -> eq '-10%', shortstyle.defaultUnit '-10%'
		it '6', -> eq '5vmin', shortstyle.defaultUnit '5vmin'

		it '7', -> eq 'calc(0.4rem + 2.1vw)', shortstyle.defaultUnit '4+2.1vw'
		it '8', -> eq 'calc(4vw + 10%)', shortstyle.defaultUnit '4vw+10%'
		it '8.1', -> eq 'calc(0.4rem + 10vw)', shortstyle.defaultUnit '4+10vw'

		it '9', -> eq 'min(1rem, 4vw)', shortstyle.defaultUnit '4vw<10'
		it '10', -> eq 'min(10%, 4vw)', shortstyle.defaultUnit '4vw<10%'
		it '11', -> eq 'max(4vw, 1rem)', shortstyle.defaultUnit '4vw>10'

		it '12', -> eq 'clamp(1rem, 4vw, 2rem)', shortstyle.defaultUnit '4vw<20>10'

		it '13', -> eq 'clamp(1rem, calc(1.2rem + 4vw), 2rem)', shortstyle.defaultUnit '12+4vw<20>10'

		it '14', -> eq 'clamp(1rem, calc(-1 * (1.2rem + 4vw)), 2rem)', shortstyle.defaultUnit '-12+4vw<20>10'

	describe 'colors', ->
		it '-', -> eq 'rgba(0, 0, 0, 0.2)', colors('bk-2')
		it '>', -> eq 'rgba(121, 157, 184, 1)', colors('bu>2')
		it '<', -> eq 'rgba(54, 70, 82, 1)', colors('bu<2')
		it '<-', -> eq 'rgba(54, 70, 82, 0.3)', colors('bu<2-3')

	describe 'edge cases', ->
		it 'empty string', -> deepEq {}, short('')
		it 'undefined string', -> deepEq {}, short(undefined)

	describe.skip 's_', ->
		it 'simple case', -> deepEq ['tac', {}], short({s_: 'tac'})

	describe 'h = height', ->
		it 'string', -> deepEq {height: '87%'}, short('h87%')
		it 'custom unit', -> deepEq {height: '87px'}, short('h87')
		it 'default unit', -> deepEq {height: '8.7rem'}, short2('h87')

	describe 'w = width', ->
		it 'default unit', -> deepEq {width: '87px'}, short('w87')

	describe.skip 'realalistic', ->
		# it '1', -> deepEq {width: '87px'}, short('h100% xc_c w18 p0_1 posr xrbe mr20:nl h60% xg1 ft4bu2')
		# it '2', -> deepEq {width: '87px'}, short('br50% _curp1 w40 h40')
		it '3', -> deepEq {width: '87px'}, short('mr20:nl')

	describe 'm = margin', ->
		it 'custom unit', -> deepEq {margin: '10px'}, short('m10')
		it 'string', -> deepEq {margin: '10vh'}, short('m10vh')
		it 'default unit', -> deepEq {margin: '1rem'}, short2('m10')

		it 'four', ->
			deepEq {margin: '0px 10px 2px 3px'}, short('m0_10_2_3')
			deepEq {margin: '1px 10vh 2vw 3%'}, short('m1_10vh_2vw_3%')
			deepEq {margin: '0.1rem 10vh 2vw 3%'}, short2('m1_10vh_2vw_3%')

		it 'two', -> deepEq {margin: '1px 10vh'}, short('m1_10vh')

		it 'mt', -> deepEq {marginTop: '10vh'}, short('mt10vh')
		it 'mb', -> deepEq {marginBottom: '10vh'}, short('mb10vh')
		it 'ml', -> deepEq {marginLeft: '10vh'}, short('ml10vh')
		it 'mr', -> deepEq {marginRight: '10vh'}, short('mr10vh')

		it 'pt', -> deepEq {paddingTop: '10vh'}, short('pt10vh')
		it 'pb', -> deepEq {paddingBottom: '10vh'}, short('pb10vh')
		it 'pl', -> deepEq {paddingLeft: '10vh'}, short('pl10vh')
		it 'pr', -> deepEq {paddingRight: '10vh'}, short('pr10vh')

	describe 'wh = whitespace', ->
		it 'simple', -> deepEq {whiteSpace: 'nowrap'}, short('whn')

	describe 'pos = position', ->
		it 'simple', -> deepEq {position: 'absolute'}, short('posa')

	describe 'ih = min-height', ->
		it 'simple', -> deepEq {minHeight: '10px'}, short('ih10')

	describe 'iw = min-width', ->
		it 'simple', -> deepEq {minWidth: '10px'}, short('iw10')

	describe 'top = top', ->
		it 'simple', -> deepEq {top: '10px'}, short('top10')

	describe 'br = border-radius', ->
		it '1', -> deepEq {borderRadius: '87px'}, short('br87')
		it '2', -> deepEq {borderRadius: '0.8rem'}, short2('br8')
		it '3', -> deepEq {borderRadius: '0px 10px 2px 3px'}, short('br0_10_2_3')

	describe 'bord = border', ->
		it '1', -> deepEq {border: '0.2rem solid rgba(0, 0, 0, 1)'}, short2('bordbk_2')
		it '2', -> deepEq {borderBottom: '2rem solid rgba(0, 0, 0, 0.5)'}, short2('borbbk-5_20')
		# it 'four', ->
		# 	deepEq {borderRadius: '0px 10px 2px 3px'}, short('br0_10_2_3')

	describe 'out = outline', ->
		it '1', -> deepEq {outline: '0.2rem solid rgba(0, 0, 0, 1)'}, short2('outbk_2')
		it '2', -> deepEq {outline: '2rem solid rgba(0, 0, 0, 0.5)'}, short2('outbk-5_20')
		it '3', -> deepEq {outline: 'none'}, short2('out0')

	describe 'xg = flexgrow', ->
		it 'simple', -> deepEq {flexGrow: 2}, short('xg2')

	describe 'ov = overflow', ->
		it '1', -> deepEq {overflow: 'hidden'}, short('ovh')
		it '2', -> deepEq {overflow: 'scroll'}, short('ovs')
		it '3', -> deepEq {overflowX: 'clip'}, short('ovxc')
		it '4', -> deepEq {overflowY: 'visible'}, short('ovyv')

	describe 'xb = flexbasis', ->
		it '1', -> deepEq {flexBasis: '2px'}, short('xb2')
		it '2', -> deepEq {flexBasis: '33.3%'}, short('xb33.3%')

	describe 'fs = font-style', ->
		it '1', -> deepEq {fontStyle: 'italic'}, short('fsi')

	describe 'transform', ->
		it 'rot', -> deepEq {transform: 'rotate(-3deg)'}, short('rot-3')
		it 'rot + scale', -> deepEq {transform: 'rotate(-4deg) scale(1.05)'}, short('rot-3 scale1.05 rot-4')


	# describe 'bg = backgroundColor', ->
	# 	it '1', ->
	# 		deepEq {backgroundColor: 'blue'}, short('bga1')

	describe 'balin = background: linear-gradient', ->
		it '1', ->
			deepEq {background: 'linear-gradient(-180deg, rgba(128, 128, 128, 0.1) 0%, rgba(204, 204, 204, 0.3) 100%)'},
			short('balinbk>5-1__bk>8-3')

	describe 'baurl = background-image: url(...)', ->
		it '1', ->
			deepEq {backgroundImage: 'url(/img/test.jpg)'}, short('baurl/img/test.jpg')

	describe 'basi = background-size: ', ->
		it '1', -> deepEq {backgroundSize: 'cover'}, short('basiv')
		it '2', -> deepEq {backgroundSize: 'auto 104%'}, short2('basia_104%')
		it '3', -> deepEq {backgroundSize: 'auto 10vmax'}, short2('basia_10vmax')
		it '4', -> deepEq {backgroundSize: 'auto 10vmin'}, short2('basia_10vmin')

	describe 'bapo = background-position: ', ->
		it '1', -> deepEq {backgroundPosition: 'center'}, short('bapoc')
		it '2', -> deepEq {backgroundPosition: 'left 50%'}, short('bapol_50%')

	describe 'f = font', ->
		it 'simple cases', ->
			fdeepEq short('fabu2-12'),
				fontSize: '12px'
				fontWeight: 200
				color: 'rgba(88, 113, 133, 1)'

		describe '_', ->
			it 'familly', ->
				# TODO: Think about how this should work
				fdeepEq short('fa___'), {}
					# fontFamily: 'Arial, sans-serif'

				# fdeepEq short('fa__'),
				# 	fontFamily: 'Arial, sans-serif'

				# fdeepEq short('fa_'),
				# 	fontFamily: 'Arial, sans-serif'

				# fdeepEq short('fa'),
				# 	fontFamily: 'Arial, sans-serif'

			it 'size', ->
				fdeepEq short('f___-12'),
					fontSize: '12px'

			it 'color', ->
				fdeepEq short('f_bu>2-1'),
					color: 'rgba(121, 157, 184, 0.1)'

			it 'weight', ->
				fdeepEq short('f__2'),
				fontWeight: 200

			it 'size + weight', ->
				fdeepEq short('f__2-12'),
				fontWeight: 200
				fontSize: '12px'

	describe 'sh = box-shadow', ->
		it '1', ->
			deepEq {boxShadow: '1px 2px 3px 4px rgba(0, 0, 0, 0.1)'}, short('sh1_2_3_4_bk-1')
		it '2', ->
			deepEq {boxShadow: '1px 2px 3px 4px rgba(0, 0, 0, 0.1), 4px 4px 4px 4px rgba(128, 128, 128, 0.2)'},
			short('sh1_2_3_4_bk-1__4_4_4_4_bk>5-2')

	describe 'tsh = text-shadow', ->
		it '1', ->
			deepEq {textShadow: '1px 2px 3px rgba(0, 0, 0, 0.1)'}, short('tsh1_2_3_bk-1')

	describe 'mix', ->
		it 'order matters', ->
			fdeepEq short('_box2 _box'),
				backgroundColor: '#FEFFEF'
				boxShadow: '0 1px 2px 0 rgba(0,0,0,0.37)'
				borderRadius: 9

		it 'support strings', ->
			fdeepEq short('_box0'),
				backgroundColor: 'red'
				boxShadow: '1 1px 3px 0 rgba(0,0,0,0.37)'
				borderRadius: 29
				padding: '2px'


	describe 'selectors & media queries', ->

		# it ':f', -> deepEq {':first-child': {marginRight: '10vh'}}, short('mr10vh:f')
		# it ':nl', -> deepEq {':not(ːlast-child)': {marginRight: '10vh'}}, short('mr10vh:nl')

		it 'hofo child', ->
			res = short 'hofoc1(p1)'
			expected = {
				'@media (hover: hover)': {':hover': {'& .c1': {padding: '1px'}}}
				':focus': {'& .c1': {padding: '1px'}}
			}
			deepEq expected, res

		it 'Edge case', ->
			res = short 'ho(p1) hoc1(p2)'
			expected =
				'@media (hover: hover)': { ':hover': {padding: '1px', '& .c1': {padding: '2px'}}}
			deepEq expected, res

		it '>(f())', ->
			res = short('ml2 <100[ml1 nl(pt5vh mr10vh)] >200[mb1 hofo(pb3 pt2)] coa(pb10)')
			expected = {
				'@media (max-width: 100px)': {
					[':not(:'+'last-child)']: { paddingTop: '5vh', marginRight: '10vh' },
					marginLeft: '1px'
				},
				'@media (min-width: 200px)':
					marginBottom: '1px',
					'@media (hover: hover)': { ':hover': {paddingBottom: '3px', paddingTop: '2px'}}
					':focus': {paddingBottom: '3px', paddingTop: '2px'}
				'@media (pointer: coarse)':
					paddingBottom: '10px'
				marginLeft: '2px'
			}

			deepEq expected, res

	describe.skip 'prio', ->
		it 'actual stype props should override', ->
			# eq 'teal', short('_box') style: {backgroundColor: 'teal'}})[1].backgroundColor

