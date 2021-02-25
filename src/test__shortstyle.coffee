{__, empty, last, match, max, min, props, test, type} = R = require 'ramda' #auto_require: ramda
{} = RE = require 'ramda-extras' #auto_require: ramda-extras
[ːlast] = ['last'] #auto_sugar
qq = (f) -> console.log match(/return (.*);/, f.toString())[1], f()
qqq = (...args) -> console.log ...args
_ = (...xs) -> xs
assert = require 'assert'
{deepEq, fdeepEq} = require 'testhelp' #auto_require: testhelp

shortstyle = require './shortstyle'

styleMaps =
	_box: ->
		backgroundColor: '#FEFFEF'
		boxShadow: '0 1px 2px 0 rgba(0,0,0,0.37)'
		borderRadius: 9

	_box2: ->
		backgroundColor: 'red'
		boxShadow: '1 1px 3px 0 rgba(0,0,0,0.37)'
		borderRadius: 29


short = shortstyle {styleMaps, unit: (x) -> if type(x) == 'Number' then x + 'px' else x}
short2 = shortstyle {styleMaps: {}}

describe 'shortstyle', ->

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
		it 'simple', -> deepEq {borderRadius: '87px'}, short('br87')
		it 'four', ->
			deepEq {borderRadius: '0px 10px 2px 3px'}, short('br0_10_2_3')

	describe 'bord = border', ->
		it '1', -> deepEq {border: '0.2rem solid rgba(0, 0, 0, 1)'}, short2('bordbk_2')
		it '2', -> deepEq {borderBottom: '2rem solid rgba(0, 0, 0, 0.5)'}, short2('borbbk-5_20')
		# it 'four', ->
		# 	deepEq {borderRadius: '0px 10px 2px 3px'}, short('br0_10_2_3')

	describe 'xg = flexgrow', ->
		it 'simple', -> deepEq {flexGrow: 2}, short('xg2')

	describe 'xb = flexbasis', ->
		it '1', -> deepEq {flexBasis: '2px'}, short('xb2')
		it '2', -> deepEq {flexBasis: '33.3%'}, short('xb33.3%')

	describe 'transform', ->
		it 'rot', -> deepEq {transform: 'rotate(-3deg)'}, short('rot-3')
		it 'rot + scale', -> deepEq {transform: 'rotate(-4deg) scale(1.05)'}, short('rot-3 scale1.05 rot-4')

	# describe 'bg = backgroundColor', ->
	# 	it '1', ->
	# 		deepEq {backgroundColor: 'blue'}, short('bga1')

	describe 'baurl = background-image: url(...)', ->
		it '1', ->
			deepEq {backgroundImage: 'url(/img/test.jpg)'}, short('baurl/img/test.jpg')

	describe 'basi = background-size: ', ->
		it '1', -> deepEq {backgroundSize: 'cover'}, short('basiv')
		it '2', -> deepEq {backgroundSize: 'auto 50%'}, short('basia_50%')

	describe 'bapo = background-position: ', ->
		it '1', -> deepEq {backgroundPosition: 'center'}, short('bapoc')
		it '2', -> deepEq {backgroundPosition: 'left 50%'}, short('bapol_50%')

	describe 'f = font', ->
		it 'simple cases', ->
			fdeepEq short('ft4bu2'),
				fontFamily: 'Times New Roman, Times, serif'
				fontSize: '12px'
				fontWeight: 200
				color: 'rgba(0, 0, 100, 1)'

		describe '_', ->
			it 'familly', ->
				fdeepEq short('ft____'),
					fontFamily: 'Times New Roman, Times, serif'

			it 'size', ->
				fdeepEq short('f_4___'),
					fontSize: '12px'

			it 'color', ->
				fdeepEq short('f__lbu_'),
					color: 'rgba(110, 200, 250, 1)'

			it 'weight', ->
				fdeepEq short('f____2'),
				fontWeight: 200

			it 'size + weight', ->
				fdeepEq short('f_4__2'),
				fontWeight: 200
				fontSize: '12px'

	describe 'sh = box-shadow', ->
		it '1', ->
			deepEq {boxShadow: '1px 2px 3px 4px rgba(0, 0, 0, 0.1)'}, short('sh1_2_3_4_bk-1'),

	describe 'mix', ->
		it 'order matters', ->
			fdeepEq short('_box2 _box'),
				backgroundColor: '#FEFFEF'
				boxShadow: '0 1px 2px 0 rgba(0,0,0,0.37)'
				borderRadius: 9


	describe 'selectors & media queries', ->

		# it ':f', -> deepEq {':first-child': {marginRight: '10vh'}}, short('mr10vh:f')
		# it ':nl', -> deepEq {':not(ːlast-child)': {marginRight: '10vh'}}, short('mr10vh:nl')

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

