#
class TreeAppApplication_People extends TreeAppApplication
    constructor: ->
        super()
         
        @name = 'People'
        @powered_with    = 'SpinalCom'
        @description = 'Create a empty list of users in the building.'
        
        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id
        
        @actions.push
            ina: _ina
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                people = @add_item_depending_selected_tree app.data, PeopleItem
