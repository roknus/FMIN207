patches-own [grass-heigth grow]
breed [ cows cow ]
cows-own [ energy ctask enfant? fear-time lifetime]
breed [ wolfs wolf ]
wolfs-own [ energy ctask ]

to setup
  clear-all
  resize-world -75 75 -75 75
  set-patch-size 10
  ask patches 
  [
    set grass-heigth 0 
    set grow 0  
  ]
  set-default-shape cows "cow"
  set-default-shape wolfs "wolf"
  create-cows cows-number
  [
    set lifetime 100
    set fear-time 0
    set enfant? false
    set ctask "gather"
    set energy random 1000
    set energy energy + 50
    set color white
    set size 2
    setxy random-xcor random-ycor 
  ]
  create-wolfs wolfs-number
  [
    set ctask "hunt"
    set energy 100
    set color red
    set size 2
    setxy random-xcor random-ycor     
  ]
  
  reset-ticks
end

to wolfs-action
  ask wolfs
  [
    if random-float 1000 < random-birth-wolfs and energy > 50 ;and count wolfs < 50
    [
      hatch-wolfs 1
      [
       set color red
       set energy energy / 2
       setxy xcor ycor
      ]
      set energy energy / 2
    ]
    run ctask
    set energy energy - 1
    if energy < 0
    [
      die
    ]
  ]
end

to hunt
  let food one-of other cows in-radius 1 with [enfant? = true]
  if food != nobody
  [
    ask food [ die ]
    if energy < 100
    [
      set energy energy + eating-gain-wolfs
    ]
  ]
  set food one-of cows in-radius 3 with [enfant? = true]
  ifelse food != nobody
  [
    set heading towards food
  ]
  [
    rt random 50
    lt random 50
  ]
  fd 1
end

to cows-action
  ask cows
  [
    set lifetime lifetime + 1
    if lifetime = 200
    [
      set enfant? false 
    ]
    if random-float 1000 < random-birth-cows and energy > 50 and count cows < 1000
    [
      set energy energy / 2
      hatch-cows 1
      [
        set lifetime 0
        set enfant? true
        set ctask "gather"
        set color white
        setxy xcor ycor
      ]
    ]
    run ctask
    if energy < 20 and not (ctask = "fear")
    [
     set ctask "eat" 
    ]
    if one-of wolfs in-radius 5 != nobody
    [
      set color blue
      set ctask "fear"
    ]
    set energy energy - 1
    if energy < 0  or lifetime > 500
    [
      die
    ]
  ]
end

to fear
  ifelse enfant?
  [
    let bad one-of wolfs in-radius 10
    if bad != nobody
    [
      set heading towards bad
    ]
    bk 0.5
  ]
  [
    run "gather" 
  ]
  set fear-time fear-time + 1
  if fear-time = 10
  [
    set color white
    set fear-time 0
    set ctask "gather" 
  ]
end

to eat
  if grass-heigth > 10
  [
    set grass-heigth (grass-heigth - 10)
    set pcolor scale-color green grass-heigth 0 100
    set energy energy + eating-gain-cows
  ]
  rt random 50
  lt random 50
  fd 1
  if energy >= 100
  [
   set ctask "gather" 
  ]
end

to gather
  let mate one-of other cows in-radius 10
  ifelse mate != nobody
  [
    if one-of other cows in-radius 2 = nobody
    [
      set heading towards mate
      fd 1
    ]
  ]
  [
   lt random 50
   rt random 50 
   fd 1
  ]
end

to grow-grass
  ask patches
    [
    ifelse pcolor = black 
      [
        if random-float 1000 < grass-grow-rate
        [ set pcolor [0 10 0] ]
      ]
      [
        ifelse grass-heigth < 50 and grow < grass-grow-interval
        [
          set grass-heigth (grass-heigth + 1)
          set pcolor scale-color green grass-heigth 0 100
          set grow 0
        ]
        [
          ifelse grass-heigth < 50
          [
           set grow (grow + 1) 
          ]
          [
            set pcolor black 
            set grass-heigth 0
            set grow 0
          ]
        ]
      ]
    ] 
end

to go
  grow-grass
  cows-action
  wolfs-action
  tick
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
1730
1551
75
75
10.0
1
10
1
1
1
0
1
1
1
-75
75
-75
75
0
0
1
ticks
30.0

BUTTON
9
10
83
43
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
126
12
189
45
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
19
67
191
100
grass-grow-rate
grass-grow-rate
0
1000
10
1
1
NIL
HORIZONTAL

SLIDER
19
107
192
140
grass-grow-interval
grass-grow-interval
0
1000
1
1
1
NIL
HORIZONTAL

SLIDER
19
146
191
179
cows-number
cows-number
0
1000
100
1
1
NIL
HORIZONTAL

PLOT
4
446
204
596
Plot
NIL
NIL
0.0
10.0
0.0
100.0
true
false
"" ""
PENS
"cows" 1.0 0 -7500403 true "" "plot count cows"
"wolfs" 1.0 0 -2674135 true "" "plot count wolfs"

SLIDER
18
227
190
260
wolfs-number
wolfs-number
0
100
40
1
1
NIL
HORIZONTAL

SLIDER
18
268
197
301
eating-gain-wolfs
eating-gain-wolfs
0
100
40
1
1
NIL
HORIZONTAL

SLIDER
18
309
197
342
eating-gain-cows
eating-gain-cows
0
100
20
1
1
NIL
HORIZONTAL

SLIDER
13
350
203
383
random-birth-cows
random-birth-cows
0
100
10
1
1
NIL
HORIZONTAL

SLIDER
10
399
200
432
random-birth-wolfs
random-birth-wolfs
0
100
10
1
1
NIL
HORIZONTAL

MONITOR
24
627
180
672
NIL
sum [energy] of cows
17
1
11

MONITOR
59
678
147
723
NIL
count wolfs
17
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -7500403 true true 135 285 195 285 270 90 30 90 105 285
Polygon -7500403 true true 270 90 225 15 180 90
Polygon -7500403 true true 30 90 75 15 120 90
Circle -1 true false 183 138 24
Circle -1 true false 93 138 24

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.0.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
