__ = require('ramda/src/__'); all = require('ramda/src/all'); contains = require('ramda/src/contains'); empty = require('ramda/src/empty'); join = require('ramda/src/join'); map = require('ramda/src/map'); match = require('ramda/src/match'); none = require('ramda/src/none'); repeat = require('ramda/src/repeat'); replace = require('ramda/src/replace'); reverse = require('ramda/src/reverse'); split = require('ramda/src/split'); tap = require('ramda/src/tap'); test = require('ramda/src/test'); type = require('ramda/src/type'); #auto_require: srcramda
{cc, $} = require 'ramda-extras' #auto_require: ramda-extras
qq = (f) -> console.log match(/return (.*);/, f.toString())[1], f()
qqq = (...args) -> console.log ...args
_ = (...xs) -> xs

_ERR = 'Shortstyle: '

colorsStatic = require './colors'

###### Probably no need to override:

defaultUnit = (x) ->
	if 'Number' == type x then x + 'px'
	else x

tryParseNum = (x) -> if isNaN x then x else Number(x)

getBaseStyleMaps = (unit = defaultUnit, colors) ->
	###### UNIT BASED

	# height
	h = (x) -> {height: unit(x)}

	# width
	w = (x) -> {width: unit(x)}

	# min/max-height
	ih = (x) -> {minHeight: unit(x)}
	xh = (x) -> {maxHeight: unit(x)}

	# min/max-width
	iw = (x) -> {minWidth: unit(x)}
	xw = (x) -> {maxWidth: unit(x)}

	# left, top, right, bottom
	lef = (x) -> {left: unit(x)}
	rig = (x) -> {right: unit(x)}
	top = (x) -> {top: unit(x)}
	bot = (x) -> {bottom: unit(x)}


	_oneTwoFour = (key) -> (x) ->
		if type(x) == 'Number' then {"#{key}": unit(x)}
		else {"#{key}": cc join(' '), map(unit), map(tryParseNum), split(' '), x}

	m = _oneTwoFour 'margin'
	m.refine = (x) -> replace /_/g, ' ', x
	p = _oneTwoFour 'padding'
	p.refine = (x) -> replace /_/g, ' ', x

	mt = (x) -> {marginTop: unit(x)}
	mb = (x) -> {marginBottom: unit(x)}
	ml = (x) -> {marginLeft: unit(x)}
	mr = (x) -> {marginRight: unit(x)}

	pt = (x) -> {paddingTop: unit(x)}
	pb = (x) -> {paddingBottom: unit(x)}
	pl = (x) -> {paddingLeft: unit(x)}
	pr = (x) -> {paddingRight: unit(x)}

	# border-radius
	br = _oneTwoFour 'borderRadius'
	br.refine = (x) -> replace /_/g, ' ', x

	lh = (x) -> {lineHeight: unit(x)}

	###### NON-UNIT BASED
	bg = (x) ->
		if x == 0 then backgroundColor: 'transparent'
		else backgroundColor: colors x

	baurl = (url) -> backgroundImage: "url(#{url})"

	basi = (x) ->
		fromX = (x) ->
			switch x
				when 'n' then 'contain'
				when 'v' then 'cover'
				when 'a' then 'auto'
				else unit x

		if ! contains '_', x then return {backgroundSize: fromX x}

		RE = /^(.*)_(.*)$/
		if ! test RE, x then throw new Error _ERR + "basi got invalid value: #{x}"
		[___, width, height] = match RE, x
		return {backgroundSize: "#{fromX(width)} #{fromX(height)}"}
				

	bare = (x) ->
		switch x
			when 'n' then {backgroundRepeat: 'no-repeat'}
			when 'x' then {backgroundRepeat: 'repeat-x'}
			when 'y' then {backgroundRepeat: 'repeat-y'}
			else throw new Error _ERR + "bare got invalid value: #{x}"

	bapo = (x) ->
		fromX = (x) ->
			switch x
				when 'c' then 'center'
				when 't' then 'top'
				when 'b' then 'bottom'
				when 'r' then 'right'
				when 'l' then 'left'
				else unit x

		x2 = fromX x
		if x2 != x then return {backgroundPosition: x2}

		RE = /^(.*)_(.*)$/
		if ! test RE, x then throw new Error _ERR + "bapo got invalid value: #{x}"
		[___, xpos, ypos] = match RE, x
		return {backgroundPosition: "#{fromX(xpos)} #{fromX(ypos)}"}

	# position
	pos = (x) ->
		switch x
			when 'a' then {position: 'absolute'}
			when 'f' then {position: 'fixed'}
			when 'r' then {position: 'relative'}
			when 's' then {position: 'static'}
			when 'y' then {position: 'sticky'}
			else throw new Error _ERR + "pos doesn't support #{x}"

	# flex-box
	x = (v) ->
		if type(v) != 'String' || v == ''
			throw new Error _ERR + 'x expects a non-empty string'

		ret = {display: 'flex'}

		di = v[0]
		if di == 'r' then ret.flexDirection = 'row'
		else if di == 'c' then ret.flexDirection = 'column'
		else if di == 't' then ret.flexDirection = 'row-reverse'
		else if di == 'v' then ret.flexDirection = 'column-reverse'
		else throw new Error _ERR + "first char in x: '#{v}' is invalid, see docs"

		jc = v[1]
		if !jc then return ret
		if jc == 'c' then ret.justifyContent = 'center'
		else if jc == 'e' then ret.justifyContent = 'flex-end'
		else if jc == 's' then ret.justifyContent = 'flex-start'
		else if jc == 'a' then ret.justifyContent = 'space-around'
		else if jc == 'b' then ret.justifyContent = 'space-between'
		else if jc == '_' then # noop
		else throw new Error _ERR + "second char in x: '#{v}' is invalid, see docs"

		ai = v[2]
		if !ai then return ret
		if ai == 'b' then ret.alignItems = 'baseline'
		else if ai == 'c' then ret.alignItems = 'center'
		else if ai == 'e' then ret.alignItems = 'flex-end'
		else if ai == 's' then ret.alignItems = 'flex-start'
		else if ai == 't' then ret.alignItems = 'strech'
		else if ai == '_' then # noop
		else throw new Error _ERR + "third char in x: '#{v}' is invalid, see docs"

		wrap = v[3]
		if !wrap then return ret
		if wrap == 'w' then ret.flexWrap = 'wrap'
		else if wrap == 'r' then ret.flexWrap = 'wrap-reverse'
		else if wrap == '_' then # noop
		else throw new Error _ERR + "fourth char in x: '#{v}' is invalid, see docs"

		# grow = v[4]
		# if !grow then return ret
		# if grow == '_' then # noop
		# else if isNaN parseInt grow
		# 	throw new Error _ERR + "fifth char in x: '#{v}' is invalid, see docs"
		# else ret.flexGrow = parseInt grow

		# shrink = v[5]
		# if !shrink then return ret
		# if shrink == '_' then # noop
		# else if isNaN parseInt shrink
		# 	throw new Error _ERR + "fifth char in x: '#{v}' is invalid, see docs"
		# else ret.flexShrink = parseInt shrink

		if v[4] then throw new Error _ERR + "x only supports 6 chars '#{v}', see docs"

		return ret

	# justify-self
	jus = (x) ->
		switch x
			when 'b' then justifySelf: 'baseline'
			when 'c' then justifySelf: 'center'
			when 's' then justifySelf: 'flex-start'
			when 'e' then justifySelf: 'flex-end'
			when 't' then justifySelf: 'strech'
			else throw new Error _ERR + "js (justify-self) received invalid value: #{x}"

	# align-self
	als = (x) ->
		switch x
			when 'b' then alignSelf: 'baseline'
			when 'c' then alignSelf: 'center'
			when 's' then alignSelf: 'flex-start'
			when 'e' then alignSelf: 'flex-end'
			when 't' then alignSelf: 'strech'
			else throw new Error _ERR + "js (align-self) received invalid value: #{x}"

	usel = (x) ->
		switch x
			when 'n'
				userSelect: 'none'
				'-webkit-tap-highlight-color': 'transparent'
			else throw new Error _ERR + "usel (user-select) got invalid type: #{x}"

	dis = (x) ->
		switch x
			when 'i' then display: 'inline'
			when 'if' then display: 'inline-flex'
			when 'b' then display: 'block'
			when 'f' then display: 'flex'
			when 'n' then display: 'none'
			else throw new Error _ERR + "dis (display) got invalid type: #{x}"

	vis = (x) ->
		switch x
			when 'h' then visibility: 'hidden'
			else throw new Error _ERR + "vis (visibility) got invalid type: #{x}"

	xg = (x) -> {flexGrow: parseInt x}
	xs = (x) -> {flexShrink: parseInt x}
	xb = (x) -> {flexBasis: unit x}

	# text-align
	ta = (x) ->
		switch x
			when 'c' then textAlign: 'center'
			when 'l' then textAlign: 'left'
			when 'r' then textAlign: 'right'
			when 'j' then textAlign: 'justify'
			else throw new Error _ERR + "ta (text-align) expects c, l, r or j,
			given: #{x}"

	td = (x) ->
		switch x
			when 'u' then textDecoration: 'underline'
			when 'n' then textDecoration: 'none'
			else throw new Error _ERR + "td (text-decoration) got invalid value #{x}"

	fs = (x) ->
		if x == 'i' then fontStyle: 'italic'
		else if x == 'n' then fontStyle: 'normal'
		else throw new Error _ERR + "fs (font-style) got invalid value #{x}"

	ttra = (x) ->
		switch x
			when 'u' then textTransform: 'uppercase'
			when 'l' then textTransform: 'lowercase'
			when 'c' then textTransform: 'capitalize'

	# ex. bordwh or bordwh_1
	bord = (x) -> border '', x
	borb = (x) -> border 'Bottom', x
	bort = (x) -> border 'Top', x
	borl = (x) -> border 'Left', x
	borr = (x) -> border 'Right', x

	border = (side, x) ->
		if x == 0 then return "border#{side}": 'none'

		RE = new RegExp("^(#{colorsStatic.REstr})(_(\\d+))?$")
		if ! test RE, x then throw new Error _ERR + "Invalid string given for border: #{x}"
		[___, clr, ____, size] = match RE, x

		return "border#{side}": "#{unit(size || 1)} solid #{colors(clr)}"

	ls = (x) -> letterSpacing: unit x


	# z-index
	z = (x) -> {zIndex: x}

	# white-space
	wh = (x) ->
		switch x
			when 'n' then whiteSpace: 'nowrap'
			when 'p' then whiteSpace: 'pre'
			when 'i' then whiteSpace: 'initial'
			else throw new Error _ERR + "wh (white-space) expects n, p or i,
			given: #{x}"

	# word-wrap
	ww = (x) ->
		switch x
			when 'b'
				# https://stackoverflow.com/a/33214667/416797
				'overflow-wrap': 'break-word';
				'word-wrap': 'break-word';

				'-ms-word-break': 'break-all';
				# This is the dangerous one in WebKit, as it breaks things wherever
				'word-break': 'break-all';
				# Instead use this non-standard one:
				'word-break': 'break-word';

				# Adds a hyphen where the word breaks, if supported (No Blink)
				'-ms-hyphens': 'auto';
				'-moz-hyphens': 'auto';
				'-webkit-hyphens': 'auto';
				'hyphens': 'auto';
			else throw new Error _ERR + "ww (word-wrap) expects b, given: #{x}"


	# overflow
	ov = (x) ->
		switch x
			when 'a' then overflow: 'auto'
			when 's' then overflow: 'scroll'
			when 'h' then overflow: 'hidden'
			when 'v' then overflow: 'visible'
			when 'i' then overflow: 'initial'
			else throw new Error _ERR + "ove (overflow) expects a, s, h, v or i,
			given: #{x}"

	# text-overflow
	tov = (x) ->
		switch x
			when 'e' then overflow: 'ellipsis'
			when 'c' then overflow: 'clip'
			when 'i' then overflow: 'initial'
			else throw new Error _ERR + "tov (text-overflow) expects e, c, or i,
			given: #{x}"

	op = (x) -> {opacity: x}

	cur = (x) ->
		switch x
			when 'p' then cursor: 'pointer'
			when 'd' then cursor: 'default'
			else throw new Error _ERR + "invalid cur(sor) '#{x}'"


	sh = (vOrVs) ->
		if vOrVs == 0 then return boxShadow: 'none'

		vs = split '__', vOrVs

		shadows = $ vs, map (v) ->
			res = match /^(-?\d+)_(-?\d+)_(\d+)_(\d+)_([a-z]{2,3}(-(\d))?)$/, v
			if !res then return warn "Invalid string given for sh (shadow): #{v}"
			[___, x, y, blur, spread] = $ res, map (s) -> unit parseInt s
			return "#{x} #{y} #{blur} #{spread} #{colors(res[5])}"

		boxShadow: $ shadows, join ', '

	tsh = (v) ->
		if v == 0 then return textShadow: 'none'
		res = match /^(-?\d+)_(-?\d+)_(\d+)_([a-z]{2,3}(-(\d))?)$/, v
		if !res then return warn "Invalid string given for tsh (text-shadow): #{v}"
		[___, x, y, blur] = $ res, map (s) -> unit parseInt s

		textShadow: "#{x} #{y} #{blur} #{colors(res[4])}"

	rot = (deg, style) -> transform deg, 'rotate', "rotate(#{deg}deg)", style
	scale = (x, style) -> transform x, 'scale', "scale(#{x})", style

	transform = (x, key, full, style) ->
		if !style.transform then {transform: full}
		else
			re = new RegExp("#{key}\\(.*?\\)")
			if test(re, style.transform) then transform: replace re, full, style.transform
			else transform: style.transform + " #{full}"

	# DEV
	bg1 = -> backgroundColor: '#FDEDED'
	bg2 = -> backgroundColor: '#EDEFFD'
	bg3 = -> backgroundColor: '#F7FDED'
	bg4 = -> backgroundColor: '#EDFDFD'
	bg5 = -> backgroundColor: '#F9B2B2'
	bg6 = -> backgroundColor: '#B3BAF9'
	bg7 = -> backgroundColor: '#E8FFC1'
	bg8 = -> backgroundColor: '#B9FAFC'

	##############################################################################
	##### Functions below this line are things you'd want to override in your app:
	##### (Implementations below are provided as inspiration / templates)

	# font
	f = (x) ->
		ret = {}
		if type(x) != 'String' then throw new Error _ERR + "font expected type string, given: #{x}"
		
		RE = ///^
		([a-z_]) # family
		([\d]{1,2}|_) # size
		([a-z]{2,3}|__) # color
		([\d_])? # weight
		$///
		if ! test RE, x then throw new Error _ERR + "Invalid string given for font: #{x}"
		[_, family, size, color, weight] = match RE, x

		switch family
			when 't' then ret.fontFamily = 'Times New Roman, Times, serif'
			when 'a' then ret.fontFamily = 'Arial, Helvetica, sans-serif'
			when 'c' then ret.fontFamily = 'Comic Sans MS, cursive, sans-serif'
			when '_' then # no-op
			else throw new Error _ERR + "invalid family '#{family}' for t: #{x}"

		switch size
			when '1' then ret.fontSize = 8 + 'px'
			when '2' then ret.fontSize = 9 + 'px'
			when '3' then ret.fontSize = 11 + 'px'
			when '4' then ret.fontSize = 12 + 'px'
			when '5' then ret.fontSize = 13 + 'px'
			when '6' then ret.fontSize = 15 + 'px'
			when '7' then ret.fontSize = 18 + 'px'
			when '8' then ret.fontSize = 25 + 'px'
			when '9' then ret.fontSize = 30 + 'px'
			when '10' then ret.fontSize = 35 + 'px'
			when '11' then ret.fontSize = 40 + 'px'
			when '_' then # no-op
			else throw new Error _ERR + "invalid size '#{size}' for t: #{x}"


		opacity = 1
		switch color
			when 'bk' then ret.color = "rgba(0, 0, 0, #{opacity})"
			when 'wh' then ret.color = "rgba(255, 255, 255, #{opacity})"
			when 're' then ret.color = "rgba(100, 0, 0, #{opacity})"
			when 'gn' then ret.color = "rgba(0, 100, 0, #{opacity})"
			when 'bu' then ret.color = "rgba(0, 0, 100, #{opacity})"
			when 'lbu' then ret.color = "rgba(110, 200, 250, #{opacity})"
			when '__' then # no-op
			else throw new Error _ERR + "invalid color '#{color}' for t: #{x}"

		switch weight
			when '_' then # noop
			when undefined then # noop
			else ret.fontWeight = parseInt(weight) * 100

		return ret

	return {h, w, ih, xh, iw, xw, lef, rig, top, bot, m, p, pos, x, xg, xs, xb, ta, z, wh, ov, tov, f, op, bg,
	br, mt, mb, ml, mr, pt, pb, pl, pr, ttra, dis, vis, td, usel, lh, ww, bord, bort, borb, borl, borr, ls, cur,
	rot, scale, sh, jus, als, baurl, basi, bapo, bare, bg1, bg2, bg3, bg4, bg5, bg6, bg7, bg8, fs, tsh}



module.exports = getBaseStyleMaps 
