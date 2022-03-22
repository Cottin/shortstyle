# Shortstyle - *Write compact styling* 🚗

**Styles written in .(s)css file:**
```css
padding-top: 10px;
padding-bottom: 20px;
padding-right: 5px;
display: flex;
flex-direction: column;
justify-content: center;
align-items: flex-end;
```

**"helper classes" from Fancy-pancy-css-lib-XYZ (or your own custom helpers):**
```js
className="pt10 pb20 pr5 flex-column justify-content-middle alien-items-end"
```

**Shortstyle:** 
```js
s="p10_5_20_0 xcce"
```



It comes with the most common functions: h, w, p, m, ...
But you can also define your own functions: wu, q, ...

## How it works:

Think of each word in the shortstyle string as a call to a styling function.

`"h10"` is a call to the function h like so `h(10)` and h is just height so it's simply:```h = (x) => {height: `${x}px`}```

`"posa"` is a call to `pos('a')`:

```js
const pos = (x) => {
   switch (x) {
      case 'a': return {position: 'absolute'};
      case 'f': return {position: 'fixed'};
      case 'r': return {position: 'relative'};
      case 's': return {position: 'static'};
      default: throw new Error(`pos doesn't support ${x}`);
   }
};
```
# API DOCS 📕
Jump to:
   - [Flexbox](#flexbox)
   - [Font](#font)
   - [Color](#color)
   - [Size](#size)
   - [Media queries](#media-queries)
   - [Hover, focus, etc.](#hover-focus-etc)

style | string-based | generated css
------------ | ------------- | -------------
|  |
**height** | `'h14'` | `height: 14`
**width** | `'w14'` | `width: 14`
**min-height** | `'ih5'` | `min-height: 5`
**min-width** | `'iw7'` | `min-width: 7`
**max-height** | `'xh20'` | `max-height: 20`
**max-width** | `'xw34'` | `max-width: 34`
**margin** | `'m10_4_2_8'` | `margin: 10 4 2 8`
 . | `'m10_5'` | `margin: 10 5`
 . | `'mt10'` | `margin-top: 10` *(top, bottom, left, right)*
**padding** | `'p10_4_2_8'` | `padding: 10 4 2 8`
 . | `'p10_5'` | `padding: 10 5`
 . | `'pt10'` | `padding-top: 10` *(top, bottom, left, right)*
**position** | `'posa'` | `position: absolute`
. | `f, r, s, y, i` | `fixed, relative, static, sticky, initial`
**top, left, ...** | `'lef10'` | `left: 10`
. | `top, bot, lef, rig` | `top, bottom, left, right`
**z-index** | `'z99'` | `z-index: 99`
**text-align** | `'tac'` | `text-align: center`
. | `l, r` | `left, right`
**vertical-align** | `'vam'` | `vertical-align: middle`
. | `m, t, b, a` | `middle, top, bottom, baseline`
**border** | `'bordbk_1'` | `border: 1px solid rgba(0, 0, 0, 1)`
. | `'bortwh_2'` | `border-top: 2px solid rgba(255, 255, 255, 1)`
. | `t, b, l, r` | `top, bottom, left, right`
**border-radius** | `'br2'` | `border-radius: 2px`
**white-space** | `'whn'` | `white-space: nowrap`
. | `p, i` | `pre, initial`
**overflow** | `'ova'` | `overflow: auto`
. | `s, h, v, i` | `scroll, hidden, visible, initial`
**text-overflow** | `'ove'` | `text-overflow: ellipsis`
. | `c, i` | `clip, initial`
**line-height** | `'lh9'` | `line-height: 9px`
**background-color** | `'bgwh'` | `background-color: rgba(255, 255, 255, 1)`
**background-url** | `'baurl/img/top.svg'` | `background-image: url(/img/top.svg)`
**background-size** | `'basi100'` | `background-size: 100px`
 . | `'basin_v'` | `background-size: contain cover`
. | `n, v, a` | `contain, cover, auto`
**background-repeat** | `'baren'` | `background-repeat: no-repeat`
. | `x, y` | `repeat-x, repeat-y`
**background-position** | `'bapoc'` | `background-position: center`
 . | `'basit_r'` | `background-position: top right`
. | `c, t, b, r, l` | `center, top, bottom, right, left`
**display** | `'disi'` | `display: inline`
. | `i, if, b, f, n, t, tr, tc` | `inline, inline-flex, block, flex, none, table, table-row, table-cell`
. | . | [also see flexbox](#flexbox)
**flex-grow** | `'xg2'` | `flex-grow: 2`
**flex-shrink** | `'xs2'` | `flex-grow: 2`
**flex-basis** | `'xb5'` | `flex-basis: 5`
**text-decoration** | `'tdu'` | `text-decoration: underline`
. | `n` | `none`
**font-style** | `'fsi'` | `font-style: italic`
. | `n` | `none`
**text-transform** | `'ttrau'` | `text-transform: uppercase`
. | `u, l, c, n` | `uppercase, lowercase, capitalize, none`
**letter-spacing** | `'ls4'` | `letter-spacing: 4px`
**word-wrap** | `'wwb'` | `overflow-wrap: break-word; word-wrap: break-word;`
**opacity** | `'op3'` | `opacity: 3`
**cursor** | `'curp'` | `cursor: pointer`
. | `p, d` | `pointer, default`
**box-shadow** | `'sh1_2_3_4_bk-2'` | `box-shadow: 1px 2px 3px 4px rgba(0, 0, 0, 0.2)`
. | `'sh1_2_3_4_bk-2__1_2_3_4_bu-8'` | `box-shadow: ... , ...`
**text-shadow** | `'tsh1_2_3_4_bk-2'` | `text-shadow: 1px 2px 3px 4px rgba(0, 0, 0, 0.2)`
**transform rotate** | `'rot180'` | `transform: rotate(45deg)`
**transform scale** | `'scale1.25'` | `transform: scale(1.25)`
**fill** | `'fillbk'` | `fill: rgba(0, 0, 0, 1)`
. | `n` | `none`
**stroke** | `'strokebk'` | `stroke: rgba(0, 0, 0, 1)`
. | `n` | `none`
**dev helpers** | `'bg1, bg2, ..., bg8'` | `background-color: ...`

            

### Flexbox
Flex is done by 4 character each representing a flex property
```
# 
eg. 'xcce'

   flex-direction (r = row, c = column)
   |  justify-content (c = center, e = flex-end, s = flex-start, a = space-around, b = space-between)
   |  |  align-items (c = center, e = flex-end, s = flex-start, b = baseline, t = stretch)
   |  |  |  flex-wrap (w = wrap, r = wrap-reverse)
   |  |  |  |
   |  |  |  |
   |  |  |  |
   v  v  v  v
x  c  c  e  w

# Examples:
xcce => display: flex; flex-direction: column; justify-content: center; align-items: flex-end;
xcc => display: flex; flex-direction: column; justify-content: center;
x__cr => display: flex; align-items: center; flex-wrap: wrap-reverse;
```


### Font
A font function can typically give the following behaviour
```

   font-family (eg. t = Times New Roman, a = Arial, ...)
   |  font-size (number unit)
   |  |  color (eg. bk = black, re = red, bu = blue, ...)
   |  |  |  font-weight (eg. number unit * 100)
   |  |  |  |
   |  |  |  |
   |  |  |  |
   v  v  v  v
f  t  5  bu 7

# Examples:
ft5bu7 => font-family: Times; font-size: 1.125rem; color: blue; font-weight: 700;
fa5__2 => font-family: Arial; font-size: 1.125rem; font-weight: 200;
f_9___ => font-size: 1.6rem;
```

### Color
Define colors for each project as a map of HSB values like so:

    const colors = shortstyle.colors.buildColors({
        wh: [0, 0, 100],            // white
        bk: [0, 0, 0],              // black 

        re: [0, 100, 100],           // red
        rea: [11, 14, 74],          // red variation a

        bu: [196, 15, 100],         // blue
        bua: [200, 100, 70],        // blue variation a
        bub: [206, 75, 66],         // blue variation b

        '!!': [300, 100, 100],      // Customize the color for unrecognized colors, defaults to fuchsia
    })

Suggested shorthands:

    bk = black
    wh = white
    re = red
    gn = green
    bu = blue
    ye = yellow
    be = beige
    pu = purple
    bw = brown

Adjusment of brightness (lighter/darker)

    bk>2    // black + 20 lighter = [0, 0, 0+20] = dark gray
    wh<3    // white - 30 darker = [0, 0, 100-30] = light gray 

Adjustment of opacity

    bk-1    // black with 10% opacity
    re-5    // red with 50% opacity

    bu<2-3  // blue darker -20 opacity 30%


### Size
With, height, font size, padding, margin... When it comes to sizing things there are many options and ways to do it; `px`, `rem`, `vw`, `vh` or maybe using `calc(...)` to dynamically set your size.

Shortstyle gives you a `defaultUnit` function that lets you do sizing in a concise way.

    // Basics 
    w10       // width: 1rem   (note that we're using rem and dividing by 10 by default)
    w10px     // width: 10px
    w10%      // width: 10%
    w10vw     // width: 10vw
    w10vh     // width: 10vh
    w10vmin   // width: 10vmin
    w10vmax   // width: 10vmax
    ml-4      // margin-left: -0.4rem

    // Added extra
    w20+5vw       // width: calc(2rem + 5vw)
    pt2+3vh       // padding-top: calc(2rem + 3vh)

    // Min and max boundaries (good for padding, margin etc. since there's no max-margin or min-padding yet)
    p4vw<10%          // padding: min(10%, 4vw)
    p4vw<10>20        // padding: clamp(1rem, 4vw, 2rem)
    m12+4vw<10>20     // margin: clamp(1rem, calc(1.2rem + 4vw), 2rem)
    ml-12+4vw<10>20   // margin-left: clamp(1rem, calc(-1 * (1.2rem + 4vw)), 2rem)


## Setup
Use the `styleSetup` helper to configure the basic styling for your project.

    const styleObjs = shortstyle.styleSetup({
        family: '-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Droid Sans,Helvetica Neue,sans-serif',
        bg: colors('be')
        colors: colors // your color object defined above using buildColors helper
        styleMaps: {
            // Custom style maps if you feel something is missing
            // or want to create project specific functions
            _sh1: (x) => {boxShadow: '0 -1px 3px 0 rgba(0,0,0,0.24)'}
        }
    }



# Questions?
Does this affect performance? Not much in most cases thanks to optimizations.
