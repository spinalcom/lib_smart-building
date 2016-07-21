#
class EventsListItem extends TreeItem
    constructor: ( name = "Events" ) ->
        super()

        @_name.set name
        @_viewable.set false
      
    
#     display_suppl_context_actions: ( context_action )  ->
#         context_action.push  new TreeAppModule_Floors
#    
#     accept_child: ( ch ) ->
#         ch instanceof FloorItem


