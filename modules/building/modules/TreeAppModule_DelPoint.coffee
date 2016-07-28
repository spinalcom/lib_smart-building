#
class TreeAppModule_DelPoint extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'DelPoint'
        @visible = false

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id


        @actions.push
            txt: "Delete point"
            fa : "fa-eraser"
            siz: 1
            key: [ "Del" ]
            ina: _ina
            vis: false
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                cam_info = app.selected_canvas_inst()[ 0 ].cm.cam_info                    
                for it in app.data.get_selected_tree_items() when it instanceof ZoneItem
                    if it._mesh?
                        it._mesh.delete_selected_point cam_info
                        console.log it._mesh

                               