{empty, max, min, none, repeat, replace, reverse, test, type, wrap} = require 'ramda' #auto_require:ramda
{cc} = require 'ramda-extras'

_ERR = 'Shortstyle: '

##### Probably no need to override:

# z-index
z = (x) -> {zIndex: x}

# height
h = (x) -> {height: x + 'px'}
hp = (x) -> {height: x + '%'}
hh = (x) -> {height: x + 'vh'}
hw = (x) -> {height: x + 'vw'}
hr = (x) -> {height: x + 'rem'}
he = (x) -> {height: x + 'em'}

# width
w = (x) -> {width: x + 'px'}
wp = (x) -> {width: x + '%'}
wh = (x) -> {width: x + 'vh'}
ww = (x) -> {width: x + 'vw'}
wr = (x) -> {width: x + 'rem'}
we = (x) -> {width: x + 'em'}

# min/max-height
ih = (x) -> {minHeight: x + 'px'}
xh = (x) -> {maxHeight: x + 'px'}

# min/max-width
iw = (x) -> {minWidth: x + 'px'}
xw = (x) -> {maxWidth: x + 'px'}

# position
pos = (x) ->
	switch x
		when 'a' then {position: 'absolute'}
		when 'f' then {position: 'fixed'}
		when 'r' then {position: 'relative'}
		when 's' then {position: 'static'}
		else throw new Error _ERR + "pos doesn't support #{x}"

# left
le = (x) -> {left: x + 'px'}
lep = (x) -> {left: x + '%'}
leh = (x) -> {left: x + 'vh'}
lew = (x) -> {left: x + 'vw'}

# top
to = (x) -> {top: x + 'px'}
top = (x) -> {top: x + '%'}
toh = (x) -> {top: x + 'vh'}
tow = (x) -> {top: x + 'vw'}

# flex-box
x = (v) ->
	if type(v) != 'String' || v == ''
		throw new Error _ERR + 'x expects a non-empty string'

	ret = {}

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


_oneTwoFour = (key) -> (x) ->
	if type(x) == 'Number' then return {"#{key}": x + 'px'}

	re1 = /^-?\d+(\.\d+)?(vh|vw|%|rem){0,1}$/ 
	re2 = /^-?\d+(\.\d+)?(vh|vw|%|rem){0,1} -?\d+(\.\d+)?(vh|vw|%|rem){0,1}$/ 
	re4 = /^-?\d+(\.\d+)?(vh|vw|%|rem){0,1} -?\d+(\.\d+)?(vh|vw|%|rem){0,1} -?\d+(\.\d+)?(vh|vw|%|rem){0,1} -?\d+(\.\d+)?(vh|vw|%|rem){0,1}$/

	if test re1, x
		return {"#{key}": x}
	else if test(re2, x) || test(re4, x)
		x_ = cc replace(/(\d+) /g, '$1px '), replace(/(\d+)$/, '$1px'), x
		return {"#{key}": x_}
	else
		throw new Error _ERR + "invalid pattern for #{key} #{x}, see docs'"


m = _oneTwoFour 'margin'
p = _oneTwoFour 'padding'

br = _oneTwoFour 'borderRadius'

bo = (x) ->
	if type(x) == 'Number'
		{borderWidth: x+'px'}
	else
		{border: x}

ta = (x) ->
	switch x
		when 'c' then textAlign: 'center'
		when 'l' then textAlign: 'left'
		when 'r' then textAlign: 'rigth'
		else throw new Error _ERR + 'ta expects c, l or r, given: #{x}'

whs = (x) ->
	switch x
		when 'n' then whiteSpace: 'nowrap'
		else throw new Error _ERR + 'whs expects n given: #{x}'



##### Functions below this line are things you'd want to override in your app:
##### (Implementations below are provided as inspiration / templates)

# font
f = (x) ->
	x_ = x + ''
	if ! test /^\d{6}$/, x_
		throw new Error "t expects a 6-digit number, given: #{x}, see docs"

	ret = {}

	family = x_[0]
	if family == '1' then ret.fontFamily = 'Times New Roman, Times, serif'
	else if family == '2' then ret.fontFamily = 'Arial, Helvetica, sans-serif'
	else if family == '3' then ret.fontFamily = 'Comic Sans MS, cursive, sans-serif'
	else throw new Error _ERR + "invalid family '#{family}' for t: #{x}"

	size = parseInt x_[1]
	switch size
		when 1 then ret.fontSize = 8 + 'px'
		when 2 then ret.fontSize = 9 + 'px'
		when 3 then ret.fontSize = 11 + 'px'
		when 4 then ret.fontSize = 12 + 'px'
		when 5 then ret.fontSize = 13 + 'px'
		when 6 then ret.fontSize = 15 + 'px'
		when 7 then ret.fontSize = 18 + 'px'
		when 8 then ret.fontSize = 25 + 'px'
		when 9 then ret.fontSize = 30 + 'px'
		else throw new Error _ERR + "invalid size '#{size}' for t: #{x}"


	color = parseInt x_[2]
	opa = parseInt(x_[3])
	opacity = if opa == 0 then 1 else opa / 10
	switch color
		when 1 then ret.color = "rgba(0, 0, 0, #{opacity})"
		when 2 then ret.color = "rgba(255, 255, 255, #{opacity})"
		when 3 then ret.color = "rgba(100, 0, 0, #{opacity})"
		when 4 then ret.color = "rgba(0, 100, 0, #{opacity})"
		when 5 then ret.color = "rgba(0, 0, 100, #{opacity})"
		when 6 then ret.color = "rgba(0, 0, 200, #{opacity})"
		when 7 then ret.color = "rgba(0, 200, 0, #{opacity})"
		else throw new Error _ERR + "invalid color '#{color}' for t: #{x}"

	ret.fontWeight = parseInt(x_[4]) * 100

	shadow = parseInt x_[5]
	switch shadow
		when 0 then # noop
		when 1 then ret.textShadow = '1px 1px 1px rgba(0,0,0,0.50)'
		when 2 then ret.textShadow = '1px 2px 0px blue'
		else throw new Error _ERR + "invalid shadow '#{shadow}' for t: #{x}"

	return ret


bg = (x) ->
	switch x
		when 'a1' then {backgroundColor: 'blue'}
		when 'a2' then {backgroundColor: 'light-blue'}
		when 'b'
			backgroundImage: 'url(/public/img/bg.png)'
			backgroundRepeat: 'repeat-x'
			backgroundSize: 'contain'
		else throw new Error _ERR + "invalid background '#{x}'"







#auto_export:none_
module.exports = {z, h, hp, hh, hw, hr, he, w, wp, wh, ww, wr, we, ih, xh, iw, xw, pos, le, lep, leh, lew, to, top, toh, tow, x, m, p, br, bo, ta, whs, f, bg}