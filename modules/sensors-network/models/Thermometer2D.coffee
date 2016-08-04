
#
class Thermometer2D extends Object2D
    constructor: ( point, params = {} )->
        super(point)
        
        @size = 25
        @hitbox = [ 2, 6 ]
        
    draw_proj: ( info, proj, s ) ->
        ctx = info.ctx_2d()
        ctx.beginPath()

        x0 = proj[0] ; y0 = proj[1]
        x1 = x0 ; y1 = y0-6*s
        x2 = x1+1*s ; y2 = y1
        x3 = x2 ; y3 = y2+8*s
        
        x4 = x0 ; y4 = y0+4*s
        
        x5 = x1-1*s ; y5 = y1+1*s
        x6 = x5 ; y6 = y1

        ctx.moveTo x1, y1
        ctx.arcTo x2, y2, x3, y3, 1*s
        ctx.lineTo x3, y3
        ctx.arc x4, y4, 2*s, -1.05, Math.PI + 1.05 , false
        ctx.lineTo x5, y5
        ctx.arcTo x6, y6, x1, y1, 1*s
        ctx.fill()
        ctx.stroke()
        
        for i in [ -1 .. 4 ]
            ctx.beginPath()
            ctx.moveTo x0, y0-i*s
            ctx.lineTo x0+1*s, y0-i*s
            ctx.stroke()