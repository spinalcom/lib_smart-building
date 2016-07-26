#
class TreeAppModule_DelPoint extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'DelPoint'
        @visible = false

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id


        @actions.push
            txt: ""
            key: [ "Del" ]
            ina: _ina
            vis: false
            fun: ( evt, app ) =>
                console.log "del point"
                app.undo_manager.snapshot()
                cam_info = app.selected_canvas_inst()[ 0 ].cm.cam_info                    
                for it in app.data.get_selected_tree_items() when it instanceof ZoneItem
                    if it._mesh?
                        it._mesh.delete_selected_point cam_info
                        

                               