#
class TreeAppApplication_SensorsNetwork extends TreeAppApplication
    constructor: ->
        super()
         
        @name = 'Sensors Network'
        @powered_with    = 'SpinalCom'
        @description = 'Create a empty network of sensors in the building.'
        
        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id
        
        @actions.push
            ina: _ina
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                sensors = @add_item_depending_selected_tree app.data, SensorsNetworkItem
