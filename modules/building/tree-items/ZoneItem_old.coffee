#
class ZoneItem_old extends TreeItem
    constructor: ( name = "Zone", num = 0, id = 0 ) ->
        super()

        @_name.set name
        @_viewable.set true

        @add_attr
            name: @_name
            ID: num + id
            _num: num
            _mesh: new Mesh( not_editable: true )

        @add_attr
            display:
                surface_color: @_mesh.visualization.element_color
                edge_color: @_mesh.visualization.line_color
                _mode: 0
                    
            geometry:
                center: 
                    x: new ConstrainedVal( Math.floor(Math.random() * 80) - 40, { min: -100, max: 100, div: 200 } ) 
                    z: new ConstrainedVal( Math.floor(Math.random() * 80) - 40, { min: -100, max: 100, div: 200 } )                     
                front_left_corner:
                    x: new ConstrainedVal( -10, { min: -100, max:   0, div: 100 } ) 
                    z: new ConstrainedVal( -10, { min: -100, max:   0, div: 100 } ) 
                front_right_corner:
                    x: new ConstrainedVal(  10, { min:    0, max: 100, div: 100 } ) 
                    z: new ConstrainedVal( -10, { min: -100, max:   0, div: 100 } ) 
                back_left_corner:
                    x: new ConstrainedVal( -10, { min: -100, max:   0, div: 100 } ) 
                    z: new ConstrainedVal(  10, { min:    0, max: 100, div: 100 } )                     
                back_right_corner:
                    x: new ConstrainedVal(  10, { min:    0, max: 100, div: 100 } ) 
                    z: new ConstrainedVal(  10, { min:    0, max: 100, div: 100 } ) 
                    
                    
    draw: ( info ) ->
        if @geometry.has_been_modified() or @display._mode.has_been_modified()
            @_mesh.clear()
            if @display._mode.get() == 0
                @draw_points_flat( @_num.get() * 4 )
                @draw_elements_2d()
            else if @display._mode.get() == 1
                @draw_points_flat( @_num.get() * 4 )
                @draw_points_flat( @_num.get() * 4 + 3.8 )
                @draw_elements_3d()
    
    
    draw_points_flat: ( height ) ->
        @_mesh.add_point [ @geometry.center.x.val.get() + @geometry.front_left_corner.x.val.get(), 
                            height, 
                            @geometry.center.z.val.get() + @geometry.front_left_corner.z.val.get() ]
        @_mesh.add_point [ @geometry.center.x.val.get() + @geometry.front_right_corner.x.val.get(), 
                            height, 
                            @geometry.center.z.val.get() + @geometry.front_right_corner.z.val.get() ]
        @_mesh.add_point [  @geometry.center.x.val.get() + @geometry.back_right_corner.x.val.get(), 
                            height, 
                            @geometry.center.z.val.get() + @geometry.back_right_corner.z.val.get() ]
        @_mesh.add_point [  @geometry.center.x.val.get() + @geometry.back_left_corner.x.val.get(), 
                            height, 
                            @geometry.center.z.val.get() + @geometry.back_left_corner.z.val.get() ]

    draw_elements_2d: () ->
        el = new Element_Q4List
        el.indices.resize [ 4, 1 ]
        el.indices.set_val [ 0, 0 ], 0
        el.indices.set_val [ 1, 0 ], 1
        el.indices.set_val [ 2, 0 ], 2
        el.indices.set_val [ 3, 0 ], 3
        @_mesh.add_element el         


    draw_elements_3d: () ->
        el = new Element_Q4List
        el.indices.resize [ 4, 6 ]
        el.indices.set_val [ 0, 0 ], 0 ; el.indices.set_val [ 1, 0 ], 1 ; el.indices.set_val [ 2, 0 ], 2 ; el.indices.set_val [ 3, 0 ], 3
        el.indices.set_val [ 0, 1 ], 4 ; el.indices.set_val [ 1, 1 ], 5 ; el.indices.set_val [ 2, 1 ], 6 ; el.indices.set_val [ 3, 1 ], 7        
        el.indices.set_val [ 0, 2 ], 0 ; el.indices.set_val [ 1, 2 ], 1 ; el.indices.set_val [ 2, 2 ], 5 ; el.indices.set_val [ 3, 2 ], 4
        el.indices.set_val [ 0, 3 ], 1 ; el.indices.set_val [ 1, 3 ], 2 ; el.indices.set_val [ 2, 3 ], 6 ; el.indices.set_val [ 3, 3 ], 5
        el.indices.set_val [ 0, 4 ], 2 ; el.indices.set_val [ 1, 4 ], 3 ; el.indices.set_val [ 2, 4 ], 7 ; el.indices.set_val [ 3, 4 ], 6
        el.indices.set_val [ 0, 5 ], 3 ; el.indices.set_val [ 1, 5 ], 0 ; el.indices.set_val [ 2, 5 ], 4 ; el.indices.set_val [ 3, 5 ], 7        
        @_mesh.add_element el   


    sub_canvas_items: () ->
        [ @_mesh ]


