#
class SensorsNetworkItem extends TreeItem
    constructor: ( name = "Sensors Network" ) ->
        super()

        @_name.set name

    
    display_suppl_context_actions: ( context_action )  ->
        context_action.push  new TreeAppModule_Sensors
        context_action.push  new TreeAppModule_Display

    accept_child: ( ch ) ->
        ch instanceof SensorItem