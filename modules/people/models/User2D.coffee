
#
class User2D extends Object2D
    constructor: ( point, params = {} )->
        super(point)
        
        @size = 18
        @hitbox = [ 6, 13 ]

    draw_proj: ( info, proj, s ) ->
        ctx = info.ctx_2d()
        ctx.beginPath()
        
        
        x0 = proj[0] ; y0 = proj[1]
        x1 = x0 ; y1 = y0-5*s
        x2 = x1+6*s ; y2 = y1
        x3 = x2 ; y3 = y2+10*s
        x4 = x3-3*s ; y4 = y3
        x5 = x4 ; y5 = y4+8*s
        x6 = x5-6*s ; y6 = y5
        x7 = x6 ; y7 = y6-8*s
        x8 = x7-3*s ; y8 = y7
        x9 = x8 ; y9 = y8-10*s

        ctx.arc x1, y1-3*s, 3*s, 0, Math.PI * 2, true
        ctx.moveTo x1, y1
        ctx.arcTo x2, y2, x3, y3, 1.5*s
        ctx.arcTo x3, y3, x4, y4, 1.5*s
        ctx.arcTo x4, y4, x5, y5, 0*s
        ctx.arcTo x5, y5, x6, y6, 1.5*s
        ctx.arcTo x6, y6, x7, y7, 1.5*s
        ctx.arcTo x7, y7, x8, y8, 0*s
        ctx.arcTo x8, y8, x9, y9, 1.5*s
        ctx.arcTo x9, y9, x1, y1, 1.5*s
        ctx.lineTo x1, y1
        
        
        ctx.fill()
        ctx.stroke()
        
