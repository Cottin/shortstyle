# Shortstyle

CSS written in .(s)css file:
```
padding-top: 10px;
padding-bottom: 20px;
padding-right: 5px;
display: flex;
flex-direction: column;
justify-content: center;
align-items: flex-end;
```

"helper classes" from Fancy-pancy-css-lib-XYZ (or your own custom helpers):
```
className="pt10 pb20 pr5 flex-column justify-content-middle alien-items-end"
```

Shortstyle:
```
s="p10_5_20_0 xcce"
```


Shortstyle lets you style in the most susynced way you've ever tried.

It comes with the most common functions: h, w, p, m, ...
But you can also define your own functions: sh, q, ...

## How it works:

Think of each work in the shortstyle string as a call to a styling function.

`"h10"` is a call to the function h like so `h(10)` and h is just height so it's very simple:```h = (x) => {height: `${x}px`}```

`"posa"` is a call to `pos(a)`:

```
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
# API DOCS
[Note that you can customize the unit](#customize-the-unit)

style | string-based | generated css
------------ | ------------- | -------------
|  |
**height** | `'h14'` | `height: 14`
**width** | `'w14'` | `width: 14`
**min-height** | `'ih5'` | `min-height: 5`
**min-width** | `'iw7'` | `min-width: 7`
**max-height** | `'xh20'` | `max-height: 20`
**max-width** | `'xw34'` | `max-width: 34`
|  |
**position** | `'posa'` | `position: absolute`
. | `'posf'` | `position: fixed`
. | `'posr'` | `position: relative`
. | `'poss'` | `position: static`
**left** | `'lef10'` | `left: 10`
**right** | `'rig10'` | `right: 10`
**top** | `'top'` | `top: 10`
**bottom** | `'bot'` | `bottom: 10`
|  |
**margin** | `'m10_4_2_8'` | `margin: 10 4 2 8`
 . | `'m10_5'` | `margin: 10 5`
 . | `'mt10'` | `margin-top: 10`
 . | `'mb10'` | `margin-bottom: 10`
 . | `'ml10'` | `margin-left: 10`
 . | `'mr10'` | `margin-right: 10`
**padding** | `'p10_4_2_8'` | `padding: 10 4 2 8`
 . | `'p10_5'` | `padding: 10 5`
 . | `'pt10'` | `padding-top: 10`
 . | `'pb10'` | `padding-bottom: 10`
 . | `'pl10'` | `padding-left: 10`
 . | `'pr10'` | `padding-right: 10`
|  |
**z-index** | `'z99'` | `z-index: 99`
**text-align** | `'tac'` | `text-align: center`
. | `'tal'` | `text-align: left`
. | `'tar'` | `text-align: right`
**white-space** | `'whn'` | `white-space: nowrap`
. | `'whp'` | `white-space: pre`
. | `'whi'` | `white-space: initial`
**overflow** | `'ova'` | `overflow: auto`
. | `'ovs'` | `overflow: scroll`
. | `'ovh'` | `overflow: hidden`
. | `'ovv'` | `overflow: visible`
. | `'ovi'` | `overflow: initial`
**text-overflow** | `'ove'` | `text-overflow: ellipsis`
. | `'ovs'` | `text-overflow: scroll`
. | `'ovh'` | `text-overflow: hidden`
. | `'ovv'` | `text-overflow: visible`
. | `'ovi'` | `text-overflow: initial`

### Flexbox
Flex is done by 1-7 character each representing a flex property
```
# Property based    /    String based
x: 'ccew10'                'xccew10'

   flex-direction (r = row, c = column)
   |  justify-content (c = center, e = flex-end, s = flex-start, a = space-around, b = space-between)
   |  |  align-items (c = center, e = flex-end, s = flex-start, b = baseline, t = stretch)
   |  |  |  flex-wrap (w = wrap, r = wrap-reverse)
   |  |  |  |  flex-grow (unit)
   |  |  |  |  |  flex-shrink (unit)
   |  |  |  |  |  |
   v  v  v  v  v  v
x  c  c  e  w  1  0

# Examples:
xccew10 => display: flex; flex-direction: column; justify-content: center; align-items: flex-end; flex-wrap: wrap; flex-grow: 1; flex-shrink: 0;
xcc => display: flex; flex-direction: column; justify-content: center;
x__cr => display: flex; align-items: center; flex-wrap: wrap-reverse;
```


### Overridables
Some of the style functions are intended for you to override to get the application-specific behaviour you want.

#### Font
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



# Questions?
Does this affect performance? Not much in most cases thanks to optimizations.
