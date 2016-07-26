#
class TreeAppModule_Floors extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Floors'

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id

        # add a floor
#         @actions.push
#             txt: "Add a floor"
#             ico: "img/glyphicons-191-plus-sign.png"
#             fun: ( evt, app ) =>
#                 for path in app.data.selected_tree_items
#                     building = path[ path.length - 1 ]
#                     if building instanceof BuildingItem 
#                         id = building._children.length
#                         floor = new FloorItem ("Floor " + id), id
#                         building.add_child floor
#                         app.data.watch_item floor

        @actions.push 
            txt: "Add a floor"
            ico: "img/glyphicons-191-plus-sign.png"
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                for path in app.data.selected_tree_items
                    building = path[ path.length - 1 ]
                    if building instanceof BuildingItem 
                        id = building._children.length
                        floor = new FloorItem ("Floor " + id), id
                        building.add_child floor                    
                        app.data.watch_item floor
                        
                        floor._mesh.visualization.display_style.set "Wireframe"
                        
                        floor._mesh.add_point [ -50, floor._num.get() * 4, -50 ]
                        floor._mesh.add_point [ 50, floor._num.get() * 4, -50 ]
                        floor._mesh.add_point [ 50, floor._num.get() * 4, 50 ]
                        floor._mesh.add_point [ -50, floor._num.get() * 4, 50 ]
                        
                        floor._mesh.add_element new Element_BoundedSurf [
                            { o: +1, e: new Element_Line [ 0, 1 ] }
                            { o: +1, e: new Element_Line [ 1, 2 ] }
                            { o: +1, e: new Element_Line [ 2, 3 ] }
                            { o: +1, e: new Element_Line [ 3, 0 ] }
                        ]
                        floor.draw_edge_3d()


        # delete a floor
        @actions.push
            txt: "Delete the last floor"
            ico: "img/glyphicons-192-minus-sign.png"
            fun: ( evt, app ) =>
                for path in app.data.selected_tree_items
                    building = path[ path.length - 1 ]
                    if building instanceof BuildingItem 
                        if building._children[0]?
                            last_floor = building._children[ building._children.length - 1 ]
                            if confirm('Are you sure you want to remove the ' + last_floor._name.get() + ' (data inside will be lost) ?')
                                app.undo_manager.snapshot()
                                building.rem_child last_floor
                                app.data.delete_from_tree last_floor

#         # save on FileSystem
#         @actions.push
#             txt: "Save building"
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
#                         dir_save = "/__building__"
#                         name_save = prompt "Enter the name of your building:", item._name.get()
#                         fs.load_or_make_dir dir_save, ( d, err ) =>
#                             building_file = d.detect ( x ) -> x.name.get() == name_save
#                             if building_file?
#                                 d.remove building_file
#                             d.add_file name_save, item, model_type: "TreeItem"




                               