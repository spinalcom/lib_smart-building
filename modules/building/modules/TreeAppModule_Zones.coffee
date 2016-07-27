#
class TreeAppModule_Zones extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Floors'

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id

#         _ctx_act = ( act ) =>
#             if act.sub?
#                 return false
#             else
#                 return true

        @actions.push 
            txt: "Add a zone"
            ico: "img/glyphicons-191-plus-sign.png"
            key: [ "G" ]
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                for path in app.data.selected_tree_items
                    floor = path[ path.length - 1 ]
                    if floor instanceof FloorItem 
                        num_floor = floor._num
                        id = floor._children.length
                        zone = new ZoneItem ("Zone " + id), num_floor, id
                        floor.add_child zone                    
                        app.data.watch_item zone
                        
                        zone._mesh.visualization.display_style.set "Wireframe"
                        
                        zone._height = floor._height
                        for coord in [ [ -0.25, -0.25 ], [ 0.25, -0.25 ], [ 0.25, 0.25 ], [ -0.25, 0.25 ] ]
                            point = app.selected_canvas_inst()[ 0 ].cm.cam.get_screen_coord coord
                            point[2] = zone._num.get() * zone._height.get()
                            zone._mesh.add_point point                              
                        
#                         zone._mesh.add_point [ -10, -10, zone._num.get() * 4 ]
#                         zone._mesh.add_point [ 10, -10, zone._num.get() * 4 ]
#                         zone._mesh.add_point [ 10, 10, zone._num.get() * 4 ]
#                         zone._mesh.add_point [ -10, 10, zone._num.get() * 4 ]
                        
                        zone._mesh.add_element new Element_BoundedSurf [
                            { o: +1, e: new Element_Line [ 0, 1 ] }
                            { o: +1, e: new Element_Line [ 1, 2 ] }
                            { o: +1, e: new Element_Line [ 2, 3 ] }
                            { o: +1, e: new Element_Line [ 3, 0 ] }
                        ]

                        # pour savoir dans quel sens est l'axe Z en fonction de la camera ( Session -> Display settings -> View -> cam )
                        orientation = app.data.tree_items[0]._children[0]._children[0].cam.Y[1].get()
                        zone.draw_mesh_2d orientation
                        zone.draw_edge_3d()
                        zone.draw_mesh_3d()
                        zone.update_center()

        # delete a zone
#         @actions.push
#             txt: "Delete the last zone"
#             ico: "img/upload_icon_3.png"
#             fun: ( evt, app ) =>
#                 for path in app.data.selected_tree_items
#                     floor = path[ path.length - 1 ]
#                     if floor instanceof BuildingItem 
#                         if floor._children[0]?
#                             last_floor = floor._children[ floor._children.length - 1 ]
#                             if confirm('Are you sure you want to remove the ' + last_floor._name.get() + ' (data inside will be lost) ?')
#                                 app.undo_manager.snapshot()
#                                 floor.rem_child last_floor
#                                 app.data.delete_from_tree last_floor

#         # save on FileSystem
#         @actions.push
#             txt: "Save floor"
#             key: [ "" ]
#             ico: "img/3floppy-mount-icone-4238-64.png"
#             loc: true
#             fun: ( evt, app ) =>
#                 items = app.data.selected_tree_items
#                 for path_item in items
#                     item = path_item[ path_item.length - 1 ]
#                     console.log "saving : ", item
#                     alert "Building saved on the Hub!"
#                     if FileSystem? and FileSystem.get_inst()?
#                         fs = FileSystem.get_inst()
# #                         name = prompt "Item name", item.to_string()
#                         dir_save = "/__floor__"
#                         name_save = prompt "Enter the name of your floor:", item._name.get()
#                         fs.load_or_make_dir dir_save, ( d, err ) =>
#                             floor_file = d.detect ( x ) -> x.name.get() == name_save
#                             if floor_file?
#                                 d.remove floor_file
#                             d.add_file name_save, item, model_type: "TreeItem"




                               