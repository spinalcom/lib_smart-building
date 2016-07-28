#
class TreeAppModule_Display extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Display'

        @actions.push 
            txt: "Display children"
            fa : "fa-eye"
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                for path in app.data.selected_tree_items
                    item = path[ path.length - 1 ]
                    @display_item app, item

        @actions.push 
            txt: "Hide children"
            fa : "fa-eye-slash"
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                for path in app.data.selected_tree_items
                    item = path[ path.length - 1 ]
                    @hide_item app, item


    display_item: ( app, item ) ->
        app.data.watch_item item
        for child in item._children
            @display_item app, child
           
           
    hide_item: ( app, item ) ->
        for p in app.data.panel_id_list()  
            if app.data.visible_tree_items[ p ]?        
                for i in [ 0 ... app.data.visible_tree_items[ p ].length ]
                    if item.model_id == app.data.visible_tree_items[p][i].model_id
                        app.data.visible_tree_items[p].splice i
                        break
        for child in item._children
            @hide_item app, child