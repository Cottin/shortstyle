{__, empty, join, map, match, merge, repeat, reverse, split, test, type} = require 'ramda' #auto_require:ramda
{cc, freduce} = require 'ramda-extras' #auto_require:ramda-extras

_ERR = 'Shortstyle: '

##### Probably no need to override:

defaultUnit = (x) ->
	if type(x) == 'Number' then x + 'px'
	else x

tryParseNum = (x) -> if isNaN x then x else Number(x)

getBaseStyleMaps = (unit = defaultUnit) ->
	##### UNIT BASED

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
	p = _oneTwoFour 'padding'


	##### NON-UNIT BASED

	# position
	pos = (x) ->
		switch x
			when 'a' then {position: 'absolute'}
			when 'f' then {position: 'fixed'}
			when 'r' then {position: 'relative'}
			when 's' then {position: 'static'}
			else throw new Error _ERR + "pos doesn't support #{x}"

	# flex-box
	x = (v) ->
		if type(v) != 'String' || v == ''
			throw new Error _ERR + 'x expects a non-empty string'

		ret = {display: 'flex'}

		di = v[0]
		if di == 'r' then ret.flexDirection = 'row'
		else if di == 'c' then ret.flexDirection = 'column'
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

		grow = v[4]
		if !grow then return ret
		if grow == '_' then # noop
		else if isNaN parseInt grow
			throw new Error _ERR + "fifth char in x: '#{v}' is invalid, see docs"
		else ret.flexGrow = parseInt grow

		shrink = v[5]
		if !shrink then return ret
		if shrink == '_' then # noop
		else if isNaN parseInt shrink
			throw new Error _ERR + "fifth char in x: '#{v}' is invalid, see docs"
		else ret.flexShrink = parseInt shrink

		if v[6] then throw new Error _ERR + "x only supports 6 chars '#{v}', see docs"

		return ret

	# text-align
	ta = (x) ->
		switch x
			when 'c' then textAlign: 'center'
			when 'l' then textAlign: 'left'
			when 'r' then textAlign: 'right'
			else throw new Error _ERR + "ta (text-align) expects c, l or r,
			given: #{x}"

	# z-index
	z = (x) -> {zIndex: x}

	# white-space
	wh = (x) ->
		switch x
			when 'n' then whiteSpace: 'nowrap'
			when 'p' then whiteSpace: 'pre'
			when 'i' then whiteSpace: 'initial'
			else throw new Error _ERR + "whs (white-space) expects n, p or i,
			given: #{x}"

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


	##############################################################################
	##### Functions below this line are things you'd want to override in your app:
	##### (Implementations below are provided as inspiration / templates)

	# font
	f = (x) ->
		ret = {}
		if type(x) != 'String' then throw new Error _ERR + "font expected type string, given: #{x}"
		
		RE = /^([a-z_])([\d_]{1,2})([a-z_]{2,3})([\d_])?$/
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
			when '__' then # no-op
			else throw new Error _ERR + "invalid color '#{color}' for t: #{x}"

		switch weight
			when '_' then # noop
			when undefined then # noop
			else ret.fontWeight = parseInt(weight) * 100

		return ret


	bg = (x) ->
		switch x
			when 'a1' then {backgroundColor: 'blue'}
			when 'a2' then {backgroundColor: 'light-blue'}
			when 'b'
				backgroundImage: 'url(/public/img/bg.png)'
				backgroundRepeat: 'repeat-x'
				backgroundSize: 'contain'
			when 'lime' then {backgroundColor: 'lime'}
			when 'teal' then {backgroundColor: 'teal'}
			when 'red' then {backgroundColor: 'red'}
			else throw new Error _ERR + "invalid background '#{x}'"


	mix = (x) ->
		mixins = split ' ', x
		freduce mixins, {}, (mem, m) -> merge mem, _mixins(m)

	_mixins = (m) ->
		switch m

			when 'box' # e.g. a commonly used box in your design
				backgroundColor: '#FEFFEF'
				boxShadow: '0 1px 2px 0 rgba(0,0,0,0.37)'
				borderRadius: 9

			when 'box2' # e.g. a variation
				backgroundColor: 'red'
				boxShadow: '1 1px 3px 0 rgba(0,0,0,0.37)'
				borderRadius: 29

			when 'td' # e.g. a fake td = table cell using flex-box
				display: 'flex'
				flexGrow: 1
				flexBasis: 0
				minWidth: 0
				overflow: 'hidden'
				textOverflow: 'ellipsis'
				width: '100%'

			else throw new Error _ERR + "invalid mixin '#{m}'"
		


	return {h, w, ih, xh, iw, xw, lef, rig, top, bot, m, p, pos, x, ta, z,
	wh, ov, tov, f, bg, mix}



module.exports = getBaseStyleMaps 
