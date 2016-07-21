#
class TreeAppApplication_Events extends TreeAppApplication
    constructor: ->
        super()
         
        @name = 'Events'
        @powered_with    = 'SpinalCom'
        @description = 'Create a empty list of events.'
        
        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id
        
        @actions.push
            ina: _ina
            fun: ( evt, app ) =>
                app.undo_manager.snapshot()
                events = @add_item_depending_selected_tree app.data, EventsListItem
