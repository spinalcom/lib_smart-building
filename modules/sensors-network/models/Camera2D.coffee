
#
class Camera2D extends Object2D
    constructor: ( point, params = {} )->
        super(point)

        @size = 25
        @hitbox = [ 4, 3 ]

    draw_proj: ( info, proj, s ) ->
        ctx = info.ctx_2d()
        ctx.beginPath()
        
        x0 = proj[0] ; y0 = proj[1]
        x1 = x0+1*s ; y1 = y0+3*s
        x2 = x1-5*s ; y2 = y1
        x3 = x2 ; y3 = y2-6*s
        x4 = x3+6*s ; y4 = y3
        x5 = x4 ; y5 = y4+2*s
        x6 = x5+2*s ; y6 = y4
        x7 = x6 ; y7 = y1
        x8 = x5 ; y8 = y7-2*s
        x9 = x5 ; y9 = y1
    
        ctx.moveTo x1, y1
        ctx.arcTo x2, y2, x3, y3, 1*s
        ctx.arcTo x3, y3, x4, y4, 1*s
        ctx.arcTo x4, y4, x5, y5, 1*s
        ctx.lineTo x5, y5
        ctx.arcTo x6, y6, x7, y7, 0.2*s
        ctx.arcTo x7, y7, x8, y8, 0.2*s
        ctx.lineTo x8, y8
        ctx.arcTo x9, y9, x2, y2, 1*s

        ctx.fill()
        ctx.stroke()