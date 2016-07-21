#
class CustomSurface extends Mesh
    constructor: ( name = "Floor", num = 0 ) ->
        super()
                
        @add_point [-1,0,-1]
        @add_point [1,0,-1]
        @add_point [1,0,1]
        @add_point [-1,0,1]
        el = new Element_Q4List
        el.indices.resize [ 4, 1 ]
        el.indices.set_val [ 0, 0 ], 0
        el.indices.set_val [ 1, 0 ], 1
        el.indices.set_val [ 2, 0 ], 2
        el.indices.set_val [ 3, 0 ], 3
        @add_element el 

        @visualization.point_edition.set false




    get_movable_entities: ( res, info, pos, phase ) ->
        x = pos[ 0 ]
        y = pos[ 1 ]
        if phase == 0
            proj = info.re_2_sc.proj @point.pos.get()
            dx = x - proj[ 0 ]
            dy = y - proj[ 1 ]
            d = Math.sqrt dx * dx + dy * dy
            if d <= 10
                res.push
                    item: @point
                    dist: d
                    type: "PointMesher"
                
                        
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
                    
        return false
                    
    on_mouse_move: ( cm, evt, pos, b, old ) ->
        
        if b == "LEFT" and @_movable_entity?
            cm.undo_manager?.snapshot()
                
            p_0 = cm.cam_info.sc_2_rw.pos pos[ 0 ], pos[ 1 ]
            d_0 = cm.cam_info.sc_2_rw.dir pos[ 0 ], pos[ 1 ]
            
#             console.log p_0
#             console.log d_0
            @_movable_entity.move @_selected, @_movable_entity.pos, p_0, d_0
            
            return true

        # pre selection
#         console.log "test1"
        res = []
        x = pos[ 0 ]
        y = pos[ 1 ]
        
        proj = cm.cam_info.re_2_sc.proj @point.pos.get()
        dx = x - proj[ 0 ]
        dy = y - proj[ 1 ]
        d = Math.sqrt dx * dx + dy * dy
        if d <= 10
            res.push
                item: this
                dist: d
                
        if res.length
            res.sort ( a, b ) -> b.dist - a.dist
            if @_pre_sele.length != 1 or @_pre_sele[ 0 ] != res[ 0 ].item
                @_pre_sele.clear()
#                 console.log "test"
                @_pre_sele.push res[ 0 ].item
                
        else if @_pre_sele.length
            @_pre_sele.clear()
        
        return false