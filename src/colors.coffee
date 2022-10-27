import join from "ramda/es/join"; import match from "ramda/es/match"; import sum from "ramda/es/sum"; import test from "ramda/es/test"; #auto_require: esramda
import {mapO, $} from "ramda-extras" #auto_require: esramda-extras
_ = (xs...) -> xs

_warn = (msg, ret) ->
  console.warn msg
  return ret || 'xx'

export RE = ///^
([a-z]{2,3}) # color
([><]\d)? # adjustment of brightnes = ligher / darker
(-\d)? # opacity
$///

export REstr = "(?:[a-z]{2,3})(?:[><]\\d)?(?:-\\d)?"

# HSB - Hue Saturation Brightness
# HSV - Hue Saturation Value (same as HSB)
# HSL - Hue Saturation Lightness

# https://stackoverflow.com/questions/17242144/javascript-convert-hsb-hsv-color-to-rgb-accurately
export hsvToRgb = (_h, _s, _v) ->
  [h, s, v] = [_h/360, _s/100, _v/100]
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

export decompose = (clr) ->
  if !clr || clr == 'undefined' then return ['!!', 1.0] # be nice and help with undefined
  if ! test RE, clr then return ['!!', 1.0]
  [isMatch, base, _adj, _opacity] = match RE, clr
  adj = if !_adj then 0 else parseInt(_adj[1]) * 10 * (_adj[0] == '<' && -1 || 1)
  opacity = if _opacity then parseInt(_opacity[1]) / 10 else 1.0
  return [base, adj, opacity]


export fuchsia = _ 300, 100, 100

export buildColors = (baseColors) ->
  baseColorsRgb = $ baseColors, mapO ([h, s, b]) -> hsvToRgb h, s, b
  baseColorsRgbStr = $ baseColorsRgb, mapO join ', '

  memo = {}
  colors = (clr) ->
    if memo[clr] then return memo[clr]

    [base, adj, opacity] = decompose clr
    [h, s, b] = baseColors[base] || fuchsia
    rgb = join ', ', hsvToRgb h, s, b + adj
    return "rgba(#{rgb}, #{opacity})"

    # if ! baseColors[base] then rgb = fuchsia
    # else rgb = baseColorsRgbStr[base]
    # if adj
    #   [h, s, b] = baseColors[base]
    #   rgb = join ', ', hsvToRgb h, s, b + adj
    # return "rgba(#{rgb}, #{opacity})"

  colors.forBg = (bg) ->
    [base, opacity] = decompose bg
    # https://stackoverflow.com/a/3943023/416797
    [r, g, b] = baseColorsRgb[base]
    sum = r * 0.299 + g * 0.587 + b * 0.114
    if opacity < 0.4 then 'bk'
    else if sum > 186 then 'bk' else 'wh'

  colors.hsb = (clr) ->
    [base, opacity] = decompose clr
    if ! baseColors[base] then return baseColors['!!'] || fuchsia
    return baseColors[base]

  return colors

