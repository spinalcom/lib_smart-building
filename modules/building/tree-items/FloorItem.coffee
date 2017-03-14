#
class FloorItem extends ZoneItem
    constructor: ( name = "Floor", num = 0, id = 0 ) ->
        super(name, num, id)

        @_name.set name
        @_viewable.set true

        @rem_attr "name"

        @_mesh.visualization.display_style.num.set 1

        @rem_attr "_mesh_2d"
        @rem_attr "_mesh_3d"
        @display.rem_attr "surface_color"


    display_suppl_context_actions: ( context_action )  ->
        context_action.push new TreeAppModule_Zones
        context_action.push new TreeAppModule_DelPoint
        context_action.push new TreeAppModule_Display

    accept_child: ( ch ) ->
        (ch instanceof ZoneItem) and (not (ch instanceof FloorItem))
