assert = require 'assert'
{flip, has, max, min} = require 'ramda' #auto_require:ramda
{change, fits, diff, ydiff, changedPaths, pickRec} = require 'ramda-extras'

shortstyle = require './shortstyle'
short = shortstyle()

eq = flip assert.equal
deepEq = flip assert.deepStrictEqual
yeq = assert.equal
ydeepEq = assert.deepStrictEqual
throws = (re, f) -> assert.throws f, re
fit = (spec, o) ->
	paths = changedPaths spec
	subO = pickRec paths, o
	deepEq spec, subO
yfit = flip fit


describe 'shortstyle', ->
	describe 'z', ->
		it 'simple case', ->
			deepEq [{}, {zIndex: 100}], short({z: 100})

	describe 'h = height', ->
		it 'h = px', -> deepEq [{}, {height: '87px'}], short({h: 87})
		it 'hp = %', -> deepEq [{}, {height: '87%'}], short({hp: 87})
		it 'hh = vh', -> deepEq [{}, {height: '87vh'}], short({hh: 87})
		it 'hw = vw', -> deepEq [{}, {height: '87vw'}], short({hw: 87})

	describe 'w = width', ->
		it 'w = px', -> deepEq [{}, {width: '87px'}], short({w: 87})
		it 'wp = %', -> deepEq [{}, {width: '87%'}], short({wp: 87})
		it 'wh = vh', -> deepEq [{}, {width: '87vh'}], short({wh: 87})
		it 'ww = vw', -> deepEq [{}, {width: '87vw'}], short({ww: 87})

	describe 'ih = min-height', ->
		it 'simple case', -> deepEq [{}, {minHeight: '87px'}], short({ih: 87})

	describe 'xh = max-height', ->
		it 'simple case', -> deepEq [{}, {maxHeight: '87px'}], short({xh: 87})

	describe 'iw = min-width', ->
		it 'simple case', -> deepEq [{}, {minWidth: '87px'}], short({iw: 87})

	describe 'xw = max-width', ->
		it 'simple case', -> deepEq [{}, {maxWidth: '87px'}], short({xw: 87})

	describe 'pos = position', ->
		it 'simple cases', ->
			deepEq [{}, {position: 'absolute'}], short({pos: 'a'})
			deepEq [{}, {position: 'fixed'}], short({pos: 'f'})
			deepEq [{}, {position: 'relative'}], short({pos: 'r'})
			deepEq [{}, {position: 'static'}], short({pos: 's'})

	describe 'x = flex', ->
		it 'direction', ->
			deepEq [{}, {flexDirection: 'row'}], short({x: 'r'})
			deepEq [{}, {flexDirection: 'column'}], short({x: 'c'})
			throws /is invalid, see docs/, -> short({x: 'x'})
		it 'justify-content', ->
			fit {justifyContent: 'center'}, short({x: 'rc'})[1]
			fit {justifyContent: 'flex-end'}, short({x: 're'})[1]
			fit {justifyContent: 'flex-start'}, short({x: 'cs'})[1]
			fit {justifyContent: 'space-around'}, short({x: 'ca'})[1]
			fit {justifyContent: 'space-between'}, short({x: 'rb'})[1]
			eq false, has('justifyContent', short({x: 'r_'})[1])
			throws /is invalid, see docs/, -> short({x: 'rx'})
		it 'align-items', ->
			fit {alignItems: 'baseline'}, short({x: 'rcb'})[1]
			fit {alignItems: 'center'}, short({x: 'rec'})[1]
			fit {alignItems: 'flex-end'}, short({x: 'cse'})[1]
			fit {alignItems: 'flex-start'}, short({x: 'css'})[1]
			fit {alignItems: 'strech'}, short({x: 'cat'})[1]
			eq false, has('alignItems', short({x: 'ra_'})[1])
			throws /is invalid, see docs/, -> short({x: 'rsx'})
		it 'flex-grow', ->
			fit {flexGrow: 0}, short({x: 'rcbw0'})[1]
			fit {flexGrow: 2}, short({x: 'rcbw2'})[1]
			eq false, has('flexGrow', short({x: 'rabw_'})[1])
			throws /is invalid, see docs/, -> short({x: 'rsbwx'})
		it 'flex-shrink', ->
			fit {flexShrink: 0}, short({x: 'rcbw10'})[1]
			fit {flexShrink: 2}, short({x: 'rcbw_2'})[1]
			eq false, has('flexShrink', short({x: 'rabw0_'})[1])
			throws /is invalid, see docs/, -> short({x: 'rsbw0x'})

	describe 'm = margin', ->
		it 'simple cases', ->
			deepEq [{}, {margin: '0px 10px 2px 3px'}], short({m: '0 10 2 3'})
			deepEq [{}, {margin: '1px 10vh 2vw 3%'}], short({m: '1 10vh 2vw 3%'})
			deepEq [{}, {margin: '1px 10vh'}], short({m: '1 10vh'})
			deepEq [{}, {margin: '1px 10rem 0.1rem 3%'}], short({m: '1 10rem 0.1rem 3%'})
			deepEq [{}, {margin: '10vh'}], short({m: '10vh'})
			throws /invalid pattern/, -> short({m: '1px 10vh'})

	describe 'p = padding', ->
		it 'simple cases', ->
			deepEq [{}, {padding: '0px 10px 2px 3px'}], short({p: '0 10 2 3'})
			deepEq [{}, {padding: '1px 10vh 2vw 3%'}], short({p: '1 10vh 2vw 3%'})
			deepEq [{}, {padding: '1px 10vh'}], short({p: '1 10vh'})
			deepEq [{}, {padding: '1px 10rem 0.1rem 3%'}], short({p: '1 10rem 0.1rem 3%'})
			deepEq [{}, {margin: '10%'}], short({m: '10%'})
			throws /invalid pattern/, -> short({m: '1px 10vh'})

	describe 'f = font', ->
		it 'simple cases', ->
			ydeepEq short({f: 145721})[1],
				fontFamily: 'Times New Roman, Times, serif'
				fontSize: '12px'
				fontWeight: 200
				color: 'rgba(0, 0, 100, 0.7)'
				textShadow: '1px 1px 1px rgba(0,0,0,0.50)'
			yfit short({f: 145700})[1],
				color: 'rgba(0, 0, 100, 0.7)'

	describe 'bg = background', ->
		it 'simple cases', ->
			deepEq [{}, {backgroundColor: 'blue'}], short({bg: 'a1'})


	# lite frågetecken nu:
	# 	- box-shadow
	# 	- text-shadow
	# 	- border-radious
