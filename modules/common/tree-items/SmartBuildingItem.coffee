#
class SmartBuildingItem extends TreeItem
    constructor: ( name = "Smart Building" ) ->
        super()

        @_name.set name
        @_viewable.set false
       
        @add_child new BuildingItem
        @add_child new PeopleItem
        @add_child new SensorsNetworkItem
        @add_child new EventsListItem
        
    
    
    display_suppl_context_actions: ( context_action )  ->
        context_action.push new TreeAppModule_Display
   
    accept_child: ( ch ) ->
        ch instanceof BuildingItem or 
        ch instanceof PeopleItem or 
        ch instanceof SensorsNetworkItem or 
        ch instanceof EventsListItem 


