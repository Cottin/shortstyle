join = require('ramda/src/join'); match = require('ramda/src/match'); sum = require('ramda/src/sum'); test = require('ramda/src/test'); #auto_require: srcramda
{mapO, $} = require 'ramda-extras' #auto_require: ramda-extras
[] = [] #auto_sugar
qq = (f) -> console.log match(/return (.*);/, f.toString())[1], f()
qqq = (...args) -> console.log ...args
_ = (...xs) -> xs

_warn = (msg, ret) ->
  console.warn msg
  return ret || 'xx'

RE = ///^
([a-z]{2,3}) # color
(-(\d))? # opacity
$///

REstr = "(?:[a-z]{2,3})(?:-\\d)?"

# https://stackoverflow.com/questions/17242144/javascript-convert-hsb-hsv-color-to-rgb-accurately
hsvToRgb = (h, s, v) ->
  r = g = b = i = f = p = q = t = undefined
  i = Math.floor(h * 6)
  f = h * 6 - i
  p = v * (1 - s)
  q = v * (1 - (f * s))
  t = v * (1 - ((1 - f) * s))
  switch i % 6
    when 0 then _ r = v, g = t, b = p
    when 1 then _ r = q, g = v, b = p
    when 2 then _ r = p, g = v, b = t
    when 3 then _ r = p, g = q, b = v
    when 4 then _ r = t, g = p, b = v
    when 5 then _ r = v, g = p, b = q
  return [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)]

decompose = (clr) ->
  if !clr || clr == 'undefined' then return ['!!', 1.0] # be nice and help with undefined
  if ! test RE, clr then return ['!!', 1.0]
  [isMatch, base, ___, _opacity] = match RE, clr
  opacity = if _opacity then parseInt(_opacity) / 10 else 1.0
  return [base, opacity]


buildColors = (baseColors) ->
  baseColorsRgb = $ baseColors, mapO ([h, s, b]) -> hsvToRgb h/360, s/100, b/100
  baseColorsRgbStr = $ baseColorsRgb, mapO join ', '

  colors = (clr) ->
    [base, opacity] = decompose clr
    if ! baseColors[base] then base = '!!'
    return "rgba(#{baseColorsRgbStr[base]}, #{opacity})"

  colors.forBg = (bg) ->
    [base, opacity] = decompose bg
    # https://stackoverflow.com/a/3943023/416797
    [r, g, b] = baseColorsRgb[base]
    sum = r * 0.299 + g * 0.587 + b * 0.114
    if opacity < 0.4 then 'bk'
    else if sum > 186 then 'bk' else 'wh'

  colors.hsb = (clr) ->
    [base, opacity] = decompose clr
    if ! baseColors[base] then return baseColors['!!']
    return baseColors[base]

  return colors


#auto_export: none_
module.exports = {RE, REstr, hsvToRgb, decompose, buildColors}