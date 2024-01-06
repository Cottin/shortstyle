import join from "ramda/es/join"; import match from "ramda/es/match"; import sum from "ramda/es/sum"; import test from "ramda/es/test"; import type from "ramda/es/type"; #auto_require: esramda
import {mapO, $} from "ramda-extras" #auto_require: esramda-extras
_arr = (xs...) -> xs

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

# NOTE! HSB needs decimals to be able to convert correctly.
#       eg. #E5E2DB = rgb(229, 226, 219) = HSB 42, 4.4, 89.8
#           rounded HSB 42, 4, 90 = #E6E3DC = rgb(230, 227, 220)
#
#       Conclusion => HSB is intuitive to work with but doesen't convert exactly to rgb/hex with effects:
#                     - If you copy a hex value into sketch and copy the resulting HSB to this function, the
#                       resulting rgb will not nessesarily be correct, so don't do that
#                     - If you're finding a nice color using HSB in sketch, that will be correct
#                     - If you want a specific hex use that hex directly in your colors.coffee
#                     

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
    when 0 then _arr r = v, g = t, b = p
    when 1 then _arr r = q, g = v, b = p
    when 2 then _arr r = p, g = v, b = t
    when 3 then _arr r = p, g = q, b = v
    when 4 then _arr r = t, g = p, b = v
    when 5 then _arr r = v, g = p, b = q
  return [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)]


# https://stackoverflow.com/a/5624139/416797
export hexToRgb = (hex) ->
  # Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
  shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i
  hex = hex.replace(shorthandRegex, (m, r, g, b) ->
    r + r + g + g + b + b
  )
  result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
  if !result then return null
  return [parseInt(result[1], 16), parseInt(result[2], 16), parseInt(result[3], 16)]


# https://stackoverflow.com/a/17243070/416797
export RGBtoHSV = (r, g, b) ->
  max_ = Math.max(r, g, b)
  min_ = Math.min(r, g, b)
  d = max_ - min_
  h = undefined
  s = if max_ == 0 then 0 else d / max_
  v = max_ / 255
  switch max_
    when min_
      h = 0
    when r
      h = g - b + d * (if g < b then 6 else 0)
      h /= 6 * d
    when g
      h = b - r + d * 2
      h /= 6 * d
    when b
      h = r - g + d * 4
      h /= 6 * d

  return [h, s, v]

export decompose = (clr) ->
  if !clr || clr == 'undefined' then return ['!!', 1.0] # be nice and help with undefined
  if ! test RE, clr then return ['!!', 1.0]
  [isMatch, base, _adj, _opacity] = match RE, clr
  adj = if !_adj then 0 else parseInt(_adj[1]) * 10 * (_adj[0] == '<' && -1 || 1)
  opacity = if _opacity then parseInt(_opacity[1]) / 10 else 1.0
  return [base, adj, opacity]


export fuchsia = _arr 300, 100, 100

export buildColors = (baseColors) ->
  baseColorsRgb = $ baseColors, mapO (colorDef) ->
    if type(colorDef) == 'Array'
      [h, s, b] = colorDef
      return hsvToRgb h, s, b
    else if type(colorDef) == 'String'
      return hexToRgb colorDef
    else throw new Error 'nyi' 
  baseColorsRgbStr = $ baseColorsRgb, mapO join ', '

  memo = {}
  colors = (clr) ->
    if memo[clr] then return memo[clr]

    [base, adj, opacity] = decompose clr
    colorDef = baseColors[base] || fuchsia
    if Array.isArray colorDef
      [h, s, b] = colorDef
    else 
      [r, g, b] = baseColorsRgb[base]
      # If no adjustment, return the correct orignial color, otherwise we need to convert to HSV
      if !adj then return "rgba(#{r}, #{g}, #{b}, #{opacity})"
      [h, s, b] = RGBtoHSV r, g, b
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

