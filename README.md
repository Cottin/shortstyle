# Shortstyle

The beauty of CSS is that it's easy to learn and universally appliable to any web app. The problem is that it gets quiet verbose, e.g. centering a div could be 4 lines and 87 characters:
```
display: flex;
flex-direction: column;
justify-content: center;
align-items: flex-end;
```

So either you end up with lots of .(s)css files or you use "helper classes" from Fancy-pancy-css-lib-XYZ or create your own custom classes:
```
className="margin-bottom--half margin-top--double flex-column justify-content-middle"
```
...but with a custom design language, the simplicity of raw css is gone.

### Shortstyle lets you:
Do basic styling using the raw css knowledge that you know so well but in a very susynced way:
```
s="p10_5_20_0"    // padding: 10px 5px 20px 0px
s="xcce"          // display: flex; flex-direction: column; justify-content: center; align-items: flex-end; 
```

### There are 2 flavours:
```
# Property-based
_ {x: 'c_c', w: '100vw', h: '70vh', ih: 1000, p: '20% 20%', bg: 'blue', f: 'h___4'},
	_ {ta:'c', f: '_9re_'}, 'BASIC'
	_ {ta:'c', f: '_8wh_'}, 'Tired of the standard way of handing styling and 

# String-based
_ {s: 'xc_c w100vw h70vh ih1000 p20%_20% bgblue fi____'},
	_ {s: 'tac fh9re4'}, 'USING STRINGS'
	_ {s: 'tac fh8wh4'}, 'Tired of the standard way of handing styling and 
```


# API DOCS
[Note that you can customize the unit](#customize-the-unit)

style | property-based | string-based | generated css
------------ | ------------- | ------------- | -------------
|  |  |
**height** | `h: 14` | `'h14'` | `height: 14`
**width** | `w: 14` | `'w14'` | `width: 14`
**min-height** | `ih: 5` | `'ih5'` | `min-height: 5`
**min-width** | `iw: 7` | `'iw7'` | `min-width: 7`
**max-height** | `xh: 20` | `'xh20'` | `max-height: 20`
**max-width** | `xw: 34` | `'xw34'` | `max-width: 34`
|  |  |
**position** | `pos: 'a'` | `'posa'` | `position: absolute`
. | `pos: 'f'` | `'posf'` | `position: fixed`
. | `pos: 'r'` | `'posr'` | `position: relative`
. | `pos: 's'` | `'poss'` | `position: static`
**left** | `lef: 10` | `'lef10'` | `left: 10`
**right** | `rig: 10` | `'rig10'` | `right: 10`
**top** | `top: 10` | `'top'` | `top: 10`
**bottom** | `bot: 10` | `'bot'` | `bottom: 10`
|  |  |
**margin** | `m: '10 4 2 8'` | `'m10_4_2_8'` | `margin: 10 4 2 8`
 . | `m: '10 5'` | `'m10_5'` | `margin: 10 5`
 . | `mt: 10'` | `'mt10'` | `margin-top: 10`
 . | `mb: 10'` | `'mb10'` | `margin-bottom: 10`
 . | `ml: 10'` | `'ml10'` | `margin-left: 10`
 . | `mr: 10'` | `'mr10'` | `margin-right: 10`
**padding** | `p: '10 4 2 8'` | `'p10_4_2_8'` | `padding: 10 4 2 8`
 . | `p: '10 5'` | `'p10_5'` | `padding: 10 5`
 . | `pt: 10'` | `'pt10'` | `padding-top: 10`
 . | `pb: 10'` | `'pb10'` | `padding-bottom: 10`
 . | `pl: 10'` | `'pl10'` | `padding-left: 10`
 . | `pr: 10'` | `'pr10'` | `padding-right: 10`
|  |  |
**z-index** | `z: 99` | `'z99'` | `z-index: 99`
**text-align** | `ta: 'c'` | `'tac'` | `text-align: center`
. | `ta: 'l'` | `'tal'` | `text-align: left`
. | `ta: 'r'` | `'tar'` | `text-align: right`
**white-space** | `wh: 'n'` | `'whn'` | `white-space: nowrap`
. | `wh: 'p'` | `'whp'` | `white-space: pre`
. | `wh: 'i'` | `'whi'` | `white-space: initial`
**overflow** | `ov: 'a'` | `'ova'` | `overflow: auto`
. | `ov: 's'` | `'ovs'` | `overflow: scroll`
. | `ov: 'h'` | `'ovh'` | `overflow: hidden`
. | `ov: 'v'` | `'ovv'` | `overflow: visible`
. | `ov: 'i'` | `'ovi'` | `overflow: initial`
**text-overflow** | `tov: 'e'` | `'ove'` | `text-overflow: ellipsis`
. | `tov: 's'` | `'ovs'` | `text-overflow: scroll`
. | `tov: 'h'` | `'ovh'` | `text-overflow: hidden`
. | `tov: 'v'` | `'ovv'` | `text-overflow: visible`
. | `ov: 'i'` | `'ovi'` | `text-overflow: initial`

### Customize the unit
TODO

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
# Property based    /    String based
f: 't5bu7'                'ft5bu7'

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

#### Mixins
TODO





# Under the hood
TODO

# Questions?
Does this affect performance? Always new props sent to the element... Investigate!
