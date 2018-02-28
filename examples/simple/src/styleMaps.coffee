{__, match, merge, reduce, split} = require 'ramda' #auto_require:ramda


_ERR = 'Simple Stylemaps:'

# Overwriting t = text
f = (x) ->
	ret = {}
	[_, family, size, color, weight] = match /^([a-z_])([\d_]{1,2})([a-z_]{2,3})([\d_])/, x

	switch family
		when 'h' then ret.fontFamily = 'Helvetica, sans-serif'
		when 'v' then ret.fontFamily = 'Verdana, Arial, sans-serif'
		when 'i' then ret.fontFamily = 'Impact, sans-serif'
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
		when 're' then ret.color = "rgba(255, 0, 0, #{opacity})"
		when 'gn' then ret.color = "rgba(0, 255, 0, #{opacity})"
		when 'bu' then ret.color = "rgba(0, 0, 255, #{opacity})"
		when '__' then # no-op
		else throw new Error _ERR + "invalid color '#{color}' for t: #{x}"

	if weight != '_'
		ret.fontWeight = parseInt(weight) * 100

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