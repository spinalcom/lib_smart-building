
#
class Object2D extends Drawable
    constructor: ( point, params = {} )->
        super()
        
        @add_attr
            _position: point
            _height: 1.0
            _color: if params.color? then params.color else new Color( 255, 255, 255, 255 )
            _edge_color: if params.edge_color? then params.edge_color else new Color( 0, 0, 0, 255 )
            # behavior
            _selected : new Lst # references of selected point
            _pre_sele : new Lst # references of selected point
            
        # parameters for display size 
        @size = 25
        @scale = 1
        @hitbox = [ 1, 1 ]
        
        
    draw: ( info ) ->
        if info.ctx_type == 'gl'       
        
            # size depending on the cam zoom
            @scale = @size / info.cam.d.get()
            s = @scale * @_height.get() 

            
            proj = info.re_2_sc.proj @_position.pos.get()
            @beg_ctx info
            @draw_proj info, proj, s
            @end_ctx info
        
        
    beg_ctx: ( info ) ->
        ctx = info.ctx_2d()
        ctx.fillStyle   = @_color.to_rgba()
        ctx.lineWidth   = 1
        ctx.strokeStyle = @_edge_color.to_rgba()
        
    end_ctx: ( info ) ->
    
        
    draw_proj: ( info, proj, s ) ->
        
        
        
    # MOVE WITH MOUSE
        
    get_movable_entities: ( res, info, pos, phase ) ->
        x = pos[ 0 ]
        y = pos[ 1 ]
        if phase == 0
            proj = info.re_2_sc.proj @_position.pos.get()
            dx = Math.abs x - proj[ 0 ]
            dy = Math.abs y - proj[ 1 ]
            d = Math.min dx, dy
            if dx <= 6 * @scale * @_height.get() and dy <= 13 * @scale * @_height.get() 
                res.push
                    item: @_position
                    dist: d
                    type: "User2D"        
                        
    on_mouse_down: ( cm, evt, pos, b ) ->
        delete @_movable_entity
        
        if b == "LEFT" or b == "RIGHT"
            # look if there's a movable point under mouse
            for phase in [ 0 ... 3 ]
                # closest entity under mouse
                res = []
                @get_movable_entities res, cm.cam_info, pos, phase
                if res.length
                    res.sort ( a, b ) -> b.dist - a.dist
                    @_movable_entity = res[ 0 ].item
                    
                    if evt.ctrlKey # add / rem selection
                        @_selected.toggle_ref @_movable_entity
                        if not @_selected.contains_ref @_movable_entity
                            delete @_movable_entity
                    else
                        @_selected.clear()
                        @_selected.push @_movable_entity
                        @_movable_entity.beg_click pos
                        
                    if b == "RIGHT"
                        return false
                        
                    return true
                else
                    @_selected.clear()
                    
        return false        
        
    on_mouse_move: ( cm, evt, pos, b, old ) ->
        
        if b == "LEFT" and @_movable_entity?
            cm.undo_manager?.snapshot()
                
            p_0 = cm.cam_info.sc_2_rw.pos pos[ 0 ], pos[ 1 ]
            d_0 = cm.cam_info.sc_2_rw.dir pos[ 0 ], pos[ 1 ]
            @_movable_entity.move @_selected, @_movable_entity.pos, p_0, d_0
            
            return true
