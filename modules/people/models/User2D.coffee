# Copyright 2012 Structure Computation  www.structure-computation.com
# Copyright 2012 Hugo Leclerc
#
# This file is part of Soda.
#
# Soda is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Soda is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with Soda. If not, see <http://www.gnu.org/licenses/>.



#
class User2D extends Drawable
    constructor: ( pos = [ 0, 0, 0 ], params = {} )->
        super()
        
        @add_attr
            _position     : new Point pos
            _scale       : if params.scale? then params.scale else 1
            _color     : if params.color? then params.color else new Color( 255, 255, 255, 255 )
            _edge_color: if params.edge_color? then params.edge_color else new Color( 0, 0, 0, 255 )

    
    draw: ( info ) ->
        if info.ctx_type == 'gl'
            proj = info.re_2_sc.proj @_position.pos.get()
            @beg_ctx info
            @draw_proj info, proj
            @end_ctx info
        
        
    beg_ctx: ( info ) ->
        ctx = info.ctx_2d()
        ctx.fillStyle   = @_color.to_rgba()
        ctx.lineWidth   = 1
        ctx.strokeStyle = @_edge_color.to_rgba()
        
    end_ctx: ( info ) ->
    
        
    draw_proj: ( info, proj ) ->
        ctx = info.ctx_2d()
        ctx.beginPath()
        
        s = @_scale.get()
        
        x0 = proj[0] ; y0 = proj[1]
        x1 = x0 ; y1 = y0-18*s
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
        ctx.arcTo x9, y9, x1, y1, 2*s
        
        ctx.fill()
        ctx.stroke()
        