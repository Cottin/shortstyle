{merge, reduce, split, test} = require 'ramda' #auto_require:ramda


_ERR = 'Simple Stylemaps:'

# Overwriting t = text
f = (x) ->
	x_ = x + ''
	if ! test /^\d{6}$/, x_
		throw new Error "t expects a 6-digit number, given: #{x}, you idiot"

	ret = {}

	family = x_[0]
	if family == '1' then ret.fontFamily = 'Helvetica, sans-serif'
	else if family == '2' then ret.fontFamily = 'Verdana, Arial, sans-serif'
	else if family == '3' then ret.fontFamily = 'Impact, sans-serif'
	else throw new Error _ERR + "invalid family '#{family}' for t: #{x}"

	size = parseInt x_[1]
	switch size
		when 1 then ret.fontSize = 8 + 'px'
		when 2 then ret.fontSize = 9 + 'px'
		when 3 then ret.fontSize = 11 + 'px'
		when 4 then ret.fontSize = 12 + 'px'
		when 5 then ret.fontSize = 23 + 'px'
		when 6 then ret.fontSize = 25 + 'px'
		when 7 then ret.fontSize = 28 + 'px'
		when 8 then ret.fontSize = 35 + 'px'
		when 9 then ret.fontSize = 50 + 'px'
		else throw new Error _ERR + "invalid size '#{size}' for t: #{x}"

	color = parseInt x_[2]
	opa = parseInt(x_[3])
	opacity = if opa == 0 then 1 else opa / 10
	switch color
		when 1 then ret.color = "rgba(255, 255, 255, #{opacity})"
		when 2 then ret.color = "rgba(0, 222, 255, #{opacity})"
		when 3 then ret.color = "rgba(255, 0, 166, #{opacity})"
		else throw new Error _ERR + "invalid color '#{color}' for t: #{x}"

	ret.fontWeight = parseInt(x_[4]) * 100

	shadow = parseInt x_[5]
	switch shadow
		when 0 then # noop
		else throw new Error _ERR + "invalid shadow '#{shadow}' for t: #{x}"

	return ret

bg = (x) ->
	switch x
		when 'blue'
			backgroundImage: 'linear-gradient(0deg, #424C7F 1%, #57427F 99%)'
		when 'purple'
			background: '#6F497F'
			boxShadow: '0 2px 3px 1px rgba(0,0,0,0.40)'
		when 'red'
			backgroundImage: 'linear-gradient(0deg, #DC6237 1%, #EA9E3A 99%)'
		else throw new Error _ERR + "invalid background '#{x}'"

mix = (x) ->
	mixins = split ' ', x
	mergeM = (mem, m) -> merge mem, _mixins(m)
	reduce mergeM, {}, mixins

_mixins = (m) ->
	switch m

		when 'square' # e.g. a commonly used box in your design
			background: '#00ead5'
			boxShadow: '0 1px 2px 0 rgba(0,0,0,0.99)'
			borderRadius: 9

		when 'lined' # e.g. a commonly used box in your design
			border: '5px solid pink'

		else throw new Error _ERR + "invalid mixin '#{m}'"

#auto_export:none_
module.exports = {f, bg, mix}