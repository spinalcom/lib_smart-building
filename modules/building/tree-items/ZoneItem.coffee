#
class ZoneItem extends TreeItem_Parametric
    constructor: ( name = "Zone", num = 0, id = 0 ) ->
        super()
        
        # default values
        @_name.set name
        @_viewable.set true        
        
        # global attributes
        @add_attr
            name: @_name
            ID: num + id
            _num: num
            _height: 4
            _orientation: 1
           
        # mesh attributes
        @add_attr
            _mesh: new Mesh
            _center: new PointMesher [ 0, 0, @_num.get() * @_height.get() ], 2, 4 
            _mesh_2d: new Mesh( not_editable: true )
            _edge_3d: new Mesh( not_editable: true )
            _mesh_3d: new Mesh( not_editable: true )
        
        # mesh conditions
        @_mesh_2d.points = @_mesh.points
        @_mesh_3d.points = @_edge_3d.points
        
        @_mesh_3d.visualization.element_color.r = @_mesh_2d.visualization.element_color.r
        @_mesh_3d.visualization.element_color.g = @_mesh_2d.visualization.element_color.g
        @_mesh_3d.visualization.element_color.b = @_mesh_2d.visualization.element_color.b
        @_mesh_3d.visualization.element_color.a = @_mesh_2d.visualization.element_color.a

        @_edge_3d.visualization.line_color.r = @_mesh.visualization.line_color.r
        @_edge_3d.visualization.line_color.g = @_mesh.visualization.line_color.g
        @_edge_3d.visualization.line_color.b = @_mesh.visualization.line_color.b
        @_edge_3d.visualization.line_color.a = @_mesh.visualization.line_color.a
        
        @_mesh_2d.visualization.display_style.num.set 2
        @_mesh_3d.visualization.display_style.num.set 2
        @_edge_3d.visualization.display_style.num.set 1        
        
        # display attributes
        @add_attr
            display:
                surface_color: @_mesh_2d.visualization.element_color
                edge_color: @_mesh.visualization.line_color
                show_center: true
                _mode: 0
                _style: 0
                
        # points display attributes
        @add_attr
            center: @_center.point
            points: @_mesh.points
            
        # update attributes
        @add_attr
            _old_center : new Point
            _center_changed: new Model
            _mesh_shape_changed: new Model

        @_old_center.pos.set @center.pos.get()



    draw: ( info ) ->
        # quand on glisse-depose un capteur/user sous la zone
        if @_children.has_been_modified()
            for ch in @_children when ( ch instanceof SensorItem or ch instanceof UserItem )
                ch.update_zone this        
        
        
        # quand on crée/déplace les points du contour du mesh
        if ( @_mesh.points.has_been_modified() or @_num.has_been_modified() or @_height.has_been_modified() ) and not @_center_changed.has_been_directly_modified()
            
            for p in @_mesh.points
                if p.has_been_modified()
                    p._mv = new MoveScheme_2D_Z( - @_num.get()*@_height.get() )
                if @_num.has_been_modified() or @_height.has_been_modified() #or p.pos[1].get() != @_num.get()*@_height.get()
                    p.pos[2].set( @_num.get() * @_height.get() )
                    
#             # pour savoir dans quel sens est l'axe Z en fonction de la camera
#             orientation = info.cam.Y[1].get() 
            
            if @_mesh_2d then @draw_mesh_2d()
            if @_edge_3d then @draw_edge_3d()
            if @_mesh_2d and @_mesh_3d then @draw_mesh_3d()
            
            @update_center()
            
            @_mesh_shape_changed._signal_change()

        # quand on déplace le centre du mesh
        if @center.has_been_modified() and not @_mesh_shape_changed.has_been_directly_modified()

            @center._mv = new MoveScheme_2D_Z( @_num.get()*@_height.get() )       
            move = Vec_3.sub @center.pos.get(), @_old_center.pos.get()
            
            for p in @_mesh.points
                p.pos.set( Vec_3.add p.pos.get(), move )
            @_mesh_2d?._signal_change()
            
            if @_edge_3d then @draw_edge_3d()
            
            @_old_center.pos.set @center.pos.get() 
            @_center_changed._signal_change()
            
            
    # mettre à jour le centre quand on modifie les points du mesh
    update_center: () ->
        bc = @_mesh.bounding_coordinates()
        @center.pos[0].set (bc[0][0]+bc[0][1])/2
        @center.pos[1].set (bc[1][0]+bc[1][1])/2 
        @center.pos[2].set @_num.get() * @_height.get()   
        @_old_center.pos.set @center.pos.get()
            
            
            
    draw_mesh_2d: () ->
        tri_lst = []
        
        # boucle sur les lignes du mesh
        for segment in @_mesh._elements[0].boundaries
            ind_t1 = segment.e.indices[0].get()
            ind_t2 = segment.e.indices[1].get()    
            
            pt1 = @_mesh.points[ ind_t1 ].pos.get()
            pt2 = @_mesh.points[ ind_t2 ].pos.get()
            
            # boucle sur les autres points
            for ind_t3 in [ 0 ... @_mesh.points.length ] when ( ind_t3 != ind_t1 and ind_t3 != ind_t2 )
                
                cond1 = false; cond2 = true; cond3 = true; cond4 = true
                
                pt3 = @_mesh.points[ ind_t3 ].pos.get()

                # cond1: test si triangle pt1pt2pt3 direct                
                pvZ = Vec_3.cro( Vec_3.sub( pt2, pt1 ), Vec_3.sub( pt3, pt2 ) )[2]
                if ( pvZ <= 0 and @_orientation.get() <=0 ) or ( pvZ >= 0 and @_orientation.get() >=0 )
                    cond1 = true

                # cond2: test si triangle pt1pt2pt3 ne coupe aucun segment
                if cond1
                
                    # test coté triangle pt2pt3
                    for other_segment in @_mesh._elements[0].boundaries #when other_segment != segment
                        ind_o1 = other_segment.e.indices[0].get()
                        ind_o2 = other_segment.e.indices[1].get()
                        if ind_o1 != ind_t2 and ind_o1 != ind_t3 and ind_o2 != ind_t2 and ind_o2 != ind_t3

                            a = pt2
                            b = pt3
                            c = @_mesh.points[ ind_o1 ].pos.get()
                            d = @_mesh.points[ ind_o2 ].pos.get()
                        
                            if @is_segments_cut a, b, c, d
                                cond2 = false
                                break

                    # test coté triangle pt3pt1
                    for other_segment in @_mesh._elements[0].boundaries #when other_segment != segment
                        ind_o1 = other_segment.e.indices[0].get()
                        ind_o2 = other_segment.e.indices[1].get()
                        if ind_o1 != ind_t3 and ind_o1 != ind_t1 and ind_o2 != ind_t3 and ind_o2 != ind_t1

                            a = pt3
                            b = pt1
                            c = @_mesh.points[ ind_o1 ].pos.get()
                            d = @_mesh.points[ ind_o2 ].pos.get()
                        
                            if @is_segments_cut a, b, c, d
                                cond2 = false
                                break

                # cond3: test si aucun point à l'intérieur du triangle pt1pt2pt3
                if cond1 and cond2
                    for ind_p in [ 0 ... @_mesh.points.length ] when ( ind_p != ind_t1 and ind_p != ind_t2 and ind_p != ind_t3 )
                        
                        a = pt1; b = pt2; c = pt3
                        m = @_mesh.points[ ind_p ].pos.get()

                        ps1 = Vec_3.dot( Vec_3.cro( Vec_3.sub(b,a), Vec_3.sub(m,a) ), Vec_3.cro( Vec_3.sub(m,a), Vec_3.sub(c,a) ) )
                        ps2 = Vec_3.dot( Vec_3.cro( Vec_3.sub(a,b), Vec_3.sub(m,b) ), Vec_3.cro( Vec_3.sub(m,b), Vec_3.sub(c,b) ) )
                        ps3 = Vec_3.dot( Vec_3.cro( Vec_3.sub(a,c), Vec_3.sub(m,c) ), Vec_3.cro( Vec_3.sub(m,c), Vec_3.sub(b,c) ) )
                        
                        if ps1 >= 0 and ps2 >= 0 and ps3 >= 0
#                             console.log "le point " + ind_p + " est dans le triangle " + [ ind_t1, ind_t2, ind_t3 ]
                            cond3 = false
                            break
                
                # test si le triangle coupe un des triangles déja existant (ou si deux triangles identiques)
                if cond1 and cond2 and cond3
                    
                    for triangle in tri_lst 
                        t1 = @_mesh.points[ triangle[0] ].pos.get()
                        t2 = @_mesh.points[ triangle[1] ].pos.get()
                        t3 = @_mesh.points[ triangle[2] ].pos.get()
                        
                        # test si les triangles sont les mêmes (à l'ordre des points près)
                        lst_test1 = [ triangle[0], triangle[1], triangle[2] ].sort()
                        lst_test2 = [ ind_t1, ind_t2, ind_t3 ].sort()
                        if lst_test1.toString() == lst_test2.toString()
                            cond4 = false
                            break
                        
                        # test si les triangles se coupent
                        if @is_segments_cut( t1, t2, pt1, pt2) or @is_segments_cut( t1, t2, pt2, pt3) or @is_segments_cut( t1, t2, pt3, pt1) or @is_segments_cut( t2, t3, pt1, pt2) or @is_segments_cut( t2, t3, pt2, pt3) or @is_segments_cut( t2, t3, pt3, pt1) or @is_segments_cut( t3, t1, pt1, pt2) or @is_segments_cut( t3, t1, pt2, pt3) or @is_segments_cut( t3, t1, pt3, pt1) 
                            cond4 = false
                            break
                        
                if cond1 and cond2 and cond3 and cond4
#                     console.log "l'element " + [ ind_t1, ind_t2, ind_t3 ] + " est correct"
                    tri_lst.push [ ind_t1, ind_t2, ind_t3 ]
        
        
        # ajout derniers triangles manquants
        seg_lst = []
        unique_seg_lst = []
        for tri in tri_lst
            c1 = true; c2 = true; c3 = true
            seg1 = [ tri[0], tri[1] ]
            seg2 = [ tri[1], tri[2] ]
            seg3 = [ tri[2], tri[0] ]
            for edge_seg in @_mesh._elements[0].boundaries
                eseg = [ edge_seg.e.indices[0].get(), edge_seg.e.indices[1].get() ]
                if seg1.sort( ( a, b )-> a-b ).toString() == eseg.sort( ( a, b )-> a-b ).toString() then c1 = false
                if seg2.sort( ( a, b )-> a-b ).toString() == eseg.sort( ( a, b )-> a-b ).toString() then c2 = false
                if seg3.sort( ( a, b )-> a-b ).toString() == eseg.sort( ( a, b )-> a-b ).toString() then c3 = false
            if c1 then seg_lst.push seg1
            if c2 then seg_lst.push seg2
            if c3 then seg_lst.push seg3
                
        for s in [ 0 ... seg_lst.length ]
            s_in_double = false
            for ss in [ 0 ... seg_lst.length ] when ss != s
                if seg_lst[s].toString() == seg_lst[ss].toString() then s_in_double = true            
            if s_in_double == false
                unique_seg_lst.push seg_lst[s]
                    
                
        if unique_seg_lst.length > 0
            for s in [ 0 ... unique_seg_lst.length-1 ]
                sp0 = unique_seg_lst[s][0]
                sp1 = unique_seg_lst[s][1]
                for ss in [ s+1 ... unique_seg_lst.length ] #when ss != s
                    ssp0 = unique_seg_lst[ss][0]
                    ssp1 = unique_seg_lst[ss][1]
                    if ssp0 == sp0 or ssp0 == sp1
                        new_tri = [ sp0, sp1, ssp1 ]
                    else if ssp1 == sp0 or ssp1 == sp1
                        new_tri = [ sp0, sp1, ssp0 ]
                    else
                        continue
                
                    cond_new_tri = true
                    for triangle in tri_lst 
                        t1 = @_mesh.points[ triangle[0] ].pos.get()
                        t2 = @_mesh.points[ triangle[1] ].pos.get()
                        t3 = @_mesh.points[ triangle[2] ].pos.get()
                        
                        pt1 = @_mesh.points[ new_tri[0] ].pos.get()
                        pt2 = @_mesh.points[ new_tri[1] ].pos.get()
                        pt3 = @_mesh.points[ new_tri[2] ].pos.get()
                        
                        # test si les triangles sont les mêmes (à l'ordre des points près)
                        lst_test1 = [ triangle[0], triangle[1], triangle[2] ].sort()
                        lst_test2 = [ new_tri[0], new_tri[1], new_tri[2] ].sort()
                        if lst_test1.toString() == lst_test2.toString()
                            cond_new_tri = false
                            break
                        
                        # test si les triangles se coupent
                        if @is_segments_cut( t1, t2, pt1, pt2) or @is_segments_cut( t1, t2, pt2, pt3) or @is_segments_cut( t1, t2, pt3, pt1) or @is_segments_cut( t2, t3, pt1, pt2) or @is_segments_cut( t2, t3, pt2, pt3) or @is_segments_cut( t2, t3, pt3, pt1) or @is_segments_cut( t3, t1, pt1, pt2) or @is_segments_cut( t3, t1, pt2, pt3) or @is_segments_cut( t3, t1, pt3, pt1) 
                            cond_new_tri = false
                            break   
                    
                    if cond_new_tri then tri_lst.push new_tri

        
        # construction des elements T3
        if tri_lst.length > 0
            @_mesh_2d._elements.clear()
            el = new Element_TriangleList
            el.indices.resize [ 3, tri_lst.length ]
            for i in [ 0 ... tri_lst.length ]
                el.indices.set_val [ 0, i ], tri_lst[i][0]
                el.indices.set_val [ 1, i ], tri_lst[i][1]
                el.indices.set_val [ 2, i ], tri_lst[i][2]
            @_mesh_2d.add_element el                      



    is_segments_cut: ( a, b, c, d ) ->
        if a.toString() != c.toString() and a.toString() != d.toString() and b.toString() != c.toString() and b.toString() != d.toString()
            pv  = Vec_3.cro( Vec_3.sub(b,a), Vec_3.sub(d,c) )
            ps1 = Vec_3.dot( Vec_3.cro( Vec_3.sub(b,a), Vec_3.sub(d,a) ), Vec_3.cro( Vec_3.sub(b,a), Vec_3.sub(c,a) ) )
            ps2 = Vec_3.dot( Vec_3.cro( Vec_3.sub(d,c), Vec_3.sub(b,c) ), Vec_3.cro( Vec_3.sub(d,c), Vec_3.sub(a,c) ) )

            if ( pv[0] != 0 or pv[1] != 0 or pv[2] != 0 ) and ps1 <= 0 and ps2 <= 0
                return true
            else
                return false
        else 
            return false



    draw_edge_3d: () ->
        @_edge_3d.clear()
        
        # points 3d
        for p in @_mesh.points
            @_edge_3d.points.push p
        for p in @_mesh.points
            pp = new Point [ p.pos[0], p.pos[1], (@_num.get()+0.99) * @_height.get() ]
            @_edge_3d.points.push pp
            
        nb_pts_2d = @_mesh.points.length
        nb_lines_2d = @_mesh._elements[0].boundaries.length
        
        # contour plafond
        el = new Element_BoundedSurf
        for line in @_mesh._elements[0].boundaries
            m = { o: +1, e: new Element_Line [ line.e.indices[0].get() + nb_pts_2d, line.e.indices[1].get() + nb_pts_2d ] }
            el.boundaries.push m
        @_edge_3d.add_element el
        
        # segments murs
        for i in [ 0 ... nb_pts_2d ]
            li = new Element_Line [ i, i + nb_pts_2d ]
            @_edge_3d.add_element li


    draw_mesh_3d: () ->
        @_mesh_3d._elements.clear()
                
        # maillage du plafond
        el = new Element_TriangleList
        nb_elems_2d = @_mesh_2d._elements[0].indices._size[1]
        nb_pts_2d = @_mesh_2d.points.length
        
        el.indices.resize [ 3, 2*nb_elems_2d ]
        for i in [ 0 ... nb_elems_2d ]
            el.indices.set_val [ 0, i ], @_mesh_2d._elements[0].indices.get 3*i
            el.indices.set_val [ 1, i ], @_mesh_2d._elements[0].indices.get 3*i + 1
            el.indices.set_val [ 2, i ], @_mesh_2d._elements[0].indices.get 3*i + 2
            
            el.indices.set_val [ 0, i + nb_elems_2d ], @_mesh_2d._elements[0].indices.get( 3*i ) + nb_pts_2d
            el.indices.set_val [ 1, i + nb_elems_2d ], @_mesh_2d._elements[0].indices.get( 3*i + 1 ) + nb_pts_2d
            el.indices.set_val [ 2, i + nb_elems_2d ], @_mesh_2d._elements[0].indices.get( 3*i + 2 ) + nb_pts_2d           
            
        @_mesh_3d.add_element el
        
        # maillage des côtés
        el_side = new Element_Q4List
        el_side.indices.resize [ 4, nb_pts_2d ]
        
        
        for i in [ 0 ... @_mesh._elements[0].boundaries.length ]
            el_side.indices.set_val [ 0, i ], @_mesh._elements[0].boundaries[i].e.indices[0].get()
            el_side.indices.set_val [ 1, i ], @_mesh._elements[0].boundaries[i].e.indices[1].get()
            el_side.indices.set_val [ 2, i ], @_edge_3d._elements[0].boundaries[i].e.indices[1].get()
            el_side.indices.set_val [ 3, i ], @_edge_3d._elements[0].boundaries[i].e.indices[0].get()

#         for i in [ 0 ... nb_pts_2d-1 ]
#             console.log @_mesh_3d._elements[0].indices.get(i), @_mesh_3d._elements[0].indices.get(i+1), @_mesh_3d._elements[0].indices.get(i + nb_pts_2d + 1), @_mesh_3d._elements[0].indices.get(i + nb_pts_2d) 
#             el_side.indices.set_val [ 0, i ], @_mesh_3d._elements[0].indices.get i
#             el_side.indices.set_val [ 1, i ], @_mesh_3d._elements[0].indices.get i + 1
#             el_side.indices.set_val [ 2, i ], @_mesh_3d._elements[0].indices.get( i + 2*nb_pts_2d + 1 )        
#             el_side.indices.set_val [ 3, i ], @_mesh_3d._elements[0].indices.get( i + 2*nb_pts_2d )

        @_mesh_3d.add_element el_side
        
        
    display_suppl_context_actions: ( context_action )  ->
        context_action.push new TreeAppModule_DelPoint
        
#         suppr = new TreeAppModule
#         suppr.visible = false
#         suppr =
#             txt: "Suppr"
#             key: "S"
#             fun: ( evt, app ) =>
#                 app.undo_manager.snapshot()
#                 console.log evt
#                 console.log "G!!!"
#     
#         context_action.push suppr
#         context_action.push new TreeAppModule_Sketch
        #context_action.push new TreeAppModule_Transform
    
    accept_child: ( ch ) ->
        ch instanceof SensorItem or
        ch instanceof UserItem
        
    sub_canvas_items: ->
        lst = []      
        
        # affichage mesh 2d
        if @display._style.get() == 0 or @display._style.get() == 2
            lst.push @_mesh
        if @display._mode.get() == 0 and (@display._style.get() == 1 or @display._style.get() == 2) and @_mesh_2d
            lst.push @_mesh_2d
            
        # affichage mesh 3d
        if @display._mode.get() == 1 and ( @display._style.get() == 0 or @display._style.get() == 2 )
            lst.push @_edge_3d
        if @display._mode.get() == 1 and ( @display._style.get() == 1 or @display._style.get() == 2 ) and @_mesh_3d
            lst.push @_mesh_3d
            
        # affichage du centre
        app_data = @get_app_data()
        if @display.show_center.get() == true and app_data.selected_tree_items[0]?[ app_data.selected_tree_items[0].length-1 ].model_id == @model_id
            lst.push @_center
        return lst
        
        
    z_index: ->
        return @sub_canvas_items()[ 0 ].z_index()
        
#     disp_only_in_model_editor: ->
#         @_mesh.points

#     get_movable_entities: ( res, info, pos, phase, dry = false ) ->
#         @_mesh.get_movable_entities res, info, pos, phase, dry
#         
#             
#     on_mouse_down: ( cm, evt, pos, b ) ->
#         if b == "LEFT" or b == "RIGHT"
#             console.log "click"
#             # look if there's a movable point under mouse
#             for phase in [ 0 ... 3 ]
#                 # closest entity under mouse
#                 res = []
#                 @get_movable_entities res, cm.cam_info, pos, phase
#                 if res.length
#                     res.sort ( a, b ) -> b.dist - a.dist
#                     console.log res[ 0 ].item            
            
            
            
#         for m in @sub_canvas_items() when m instanceof Mesh
#             m.on_mouse_down cm, evt, pos, b
#         return false
        
    _closest_point_closer_than: ( proj, pos, dist ) ->
        for m in @sub_canvas_items() when m instanceof Mesh
            m._closest_point_closer_than proj, pos, dist
            
            
            
    is_app_data: ( item ) ->
        if item instanceof TreeAppData
            return true
        else
            return false
       
    get_app_data: ->
        it = @get_parents_that_check @is_app_data
        return it[ 0 ] 