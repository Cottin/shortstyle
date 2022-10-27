__ = require('ramda/src/__'); all = require('ramda/src/all'); contains = require('ramda/src/contains'); empty = require('ramda/src/empty'); join = require('ramda/src/join'); map = require('ramda/src/map'); match = require('ramda/src/match'); none = require('ramda/src/none'); repeat = require('ramda/src/repeat'); replace = require('ramda/src/replace'); reverse = require('ramda/src/reverse'); split = require('ramda/src/split'); test = require('ramda/src/test'); type = require('ramda/src/type'); #auto_require: srcramda
{cc, $} = require 'ramda-extras' #auto_require: ramda-extras
qq = (f) -> console.log match(/return (.*);/, f.toString())[1], f()
qqq = (...args) -> console.log ...args
_ = (...xs) -> xs

_ERR = 'Shortstyle: '

colorsStatic = require './colors'

###### Probably no need to override:

tryParseNum = (x) -> if isNaN x then x else Number(x)

getBaseStyleMaps = (unit, colors, families) ->
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

	RElin = new RegExp("^(#{colorsStatic.REstr})__(#{colorsStatic.REstr})$")
	balin = (clrs) ->
		[start, stop] = split '__', clrs

		if !start || !stop then throw new Error 'Not yet implemented'
		
		[___, color1, color2] = match RElin, clrs
		if !color1 || !color2 then return warn "Invalid string given for balin (background:linear-gradient): #{v}"
		return {background: "linear-gradient(-180deg, #{colors color1} 0%, #{colors color2} 100%)"}

		return grad

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
			when 'i' then {position: 'initial'}
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
				# '-webkit-tap-highlight-color': 'transparent'
			else throw new Error _ERR + "usel (user-select) got invalid type: #{x}"

	dis = (x) ->
		switch x
			when 'i' then display: 'inline'
			when 'if' then display: 'inline-flex'
			when 'b' then display: 'block'
			when 'f' then display: 'flex'
			when 'n' then display: 'none'
			when 't' then display: 'table'
			when 'tr' then display: 'table-row'
			when 'tc' then display: 'table-cell'
			else throw new Error _ERR + "dis (display) got invalid type: #{x}"

	vis = (x) ->
		switch x
			when 'h' then visibility: 'hidden'
			when 'v' then visibility: 'visible'
			else throw new Error _ERR + "vis (visibility) got invalid type: #{x}"

	xg = (x) -> {flexGrow: parseInt x}
	xs = (x) -> {flexShrink: parseInt x}
	xb = (x) -> {flexBasis: unit x}
	# xw = (wrap) ->
	# 	if wrap == 'w' then {flexWrap: 'wrap'}
	# 	else if wrap == 'r' then {flexWrap: 'wrap-reverse'}
	# 	else if wrap == '_' then {}
	# 	else throw new Error _ERR + "xw (flex-wrap) got invalid argument: #{wrap}"

	# text-align
	ta = (x) ->
		switch x
			when 'c' then textAlign: 'center'
			when 'l' then textAlign: 'left'
			when 'r' then textAlign: 'right'
			when 'j' then textAlign: 'justify'
			else throw new Error _ERR + "ta (text-align) expects c, l, r or j,
			given: #{x}"

	va = (x) ->
		switch x
			when 'm' then verticalAlign: 'middle'
			when 't' then verticalAlign: 'top'
			when 'b' then verticalAlign: 'bottom'
			when 'a' then verticalAlign: 'baseline'
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
			when 'n' then textTransform: 'none'

	# ex. bordwh or bordwh_1
	bord = (x) -> border '', x
	borb = (x) -> border 'Bottom', x
	bort = (x) -> border 'Top', x
	borl = (x) -> border 'Left', x
	borr = (x) -> border 'Right', x

	border = (side, x) ->
		if x == 0 then return "border#{side}": 'none'

		RE = new RegExp("^(#{colorsStatic.REstr})(_(\\d+(:?px)?))?$")
		if ! test RE, x then throw new Error _ERR + "Invalid string given for border: #{x}"
		[___, clr, ____, size] = match RE, x

		return "border#{side}": "#{unit(size || 1)} solid #{colors(clr)}"

	out = (x) ->
		if x == 0 then return "outline": 'none'

		RE = new RegExp("^(#{colorsStatic.REstr})(_(\\d+(:?px)?))?$")
		if ! test RE, x then throw new Error _ERR + "Invalid string given for outline: #{x}"
		[___, clr, ____, size] = match RE, x

		return "outline": "#{unit(size || 1)} solid #{colors(clr)}"

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
		if x?[0] == 'x' then key = 'overflowX'; z = x[1]
		else if x?[0] == 'y' then key = 'overflowY'; z = x[1]
		else key = 'overflow'; z = x

		switch z
			when 'a' then [key]: 'auto'
			when 's' then [key]: 'scroll'
			when 'h' then [key]: 'hidden'
			when 'c' then [key]: 'clip'
			when 'v' then [key]: 'visible'
			when 'i' then [key]: 'initial'
			else throw new Error _ERR + "ov (overflow) expects a, s, h, v, i, or put x or y in front of those
			eg. xa or ya given: #{x}"

	# text-overflow
	tov = (x) ->
		switch x
			when 'e' then textOverflow: 'ellipsis'
			when 'c' then textOverflow: 'clip'
			when 'i' then textOverflow: 'initial'
			else throw new Error _ERR + "tov (text-overflow) expects e, c, or i,
			given: #{x}"

	op = (x) -> {opacity: x}

	cur = (x) ->
		switch x
			when 'p' then cursor: 'pointer'
			when 'd' then cursor: 'default'
			else throw new Error _ERR + "invalid cur(sor) '#{x}'"


	# shx_y_blur_spread_clr = eg. sh2_3_4_2_bk>3__0_6_11_3_bk>9 (double shadow)
	REsh = new RegExp("^(-?\\d+)_(-?\\d+)_(\\d+)_(\\d+)_(#{colorsStatic.REstr})$")
	sh = (vOrVs) ->
		if vOrVs == 0 then return boxShadow: 'none'

		vs = split '__', vOrVs

		shadows = $ vs, map (v) ->
			res = match REsh, v
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

	fill = (x) ->
		if x == 0 then fill: 'none'
		else fill: colors x

	stroke = (x) ->
		if x == 0 then stroke: 'none'
		else stroke: colors x

	# DEV
	bg1 = -> backgroundColor: '#FDEDED'
	bg2 = -> backgroundColor: '#EDEFFD'
	bg3 = -> backgroundColor: '#F7FDED'
	bg4 = -> backgroundColor: '#EDFDFD'
	bg5 = -> backgroundColor: '#F9B2B2'
	bg6 = -> backgroundColor: '#B3BAF9'
	bg7 = -> backgroundColor: '#E8FFC1'
	bg8 = -> backgroundColor: '#B9FAFC'

	# font - note that you could override font if needed in your app
	f = (x) ->
		ret = {}
		if type(x) != 'String' then throw new Error _ERR + "font expected type string, given: #{x}"
		
		# eg. fabua-35-15
		RE = ///^
		([a-z_]) # family
		([a-z]{2,3}(?:[><]\d)?(?:-\d)?|_)? # color
		(\d|_)? # weight
		(?:-(.*)|_)? # size
		$///

		if ! test RE, x then throw new Error _ERR + "Invalid string given for font: #{x}"
		[___, family, clr, weight, size] = match RE, x

		switch family
			when 'a' then 'unset'
			when 'b' then ret.fontFamily = families[1]
			when 'c' then ret.fontFamily = families[2]
			when 'd' then ret.fontFamily = families[3]
			when '_' then # no-op
			else throw new Error _ERR + "invalid family '#{family}' for t: #{x}"

		if size && size != '_' then ret.fontSize = unit size

		if clr && clr != '_' then ret.color = colors clr

		switch weight
			when '_' then # noop
			when undefined then # noop
			else ret.fontWeight = parseInt(weight) * 100

		return ret

	return {h, w, ih, xh, iw, xw, lef, rig, top, bot, m, p, pos, x, xg, xs, xb, ta, z, wh, ov, tov, f, op, bg,
	br, mt, mb, ml, mr, pt, pb, pl, pr, ttra, dis, vis, td, usel, lh, ww, bord, bort, borb, borl, borr, out, ls, cur,
	rot, scale, sh, jus, als, baurl, balin, basi, bapo, bare, bg1, bg2, bg3, bg4, bg5, bg6, bg7, bg8, fs, tsh,
	fill, stroke, va}



module.exports = getBaseStyleMaps 
