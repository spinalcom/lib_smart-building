#
class TreeAppApplication_Building extends TreeAppApplication
    constructor: ->
        super()
         
        @name = 'Building'
        @powered_with    = 'SpinalCom'
        @description = 'Create a empty building model.'
        
        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id
        
        @actions.push
            ina: _ina
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                building = @add_item_depending_selected_tree app.data, BuildingItem
