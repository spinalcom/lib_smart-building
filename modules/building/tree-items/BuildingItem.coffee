#
class BuildingItem extends TreeItem
    constructor: ( name = "Building" ) ->
        super()

        @_name.set name
        @_viewable.set false
       
        @add_attr
            display:
                mode: new Choice( 0, [ "2D", "3D" ])
                style: new Choice( 2, [ "Wireframe", "Surface", "Surface with edges" ])
       
       
        @bind =>
            if @_children.has_been_modified()
                for i in [ 0 ... @_children.length ]
                    @_children[i]._name.set 'Floor ' + i
                    @_children[i]._num.set i
                    @_children[i].ID.set i
                    @_children[i].display._mode = @display.mode.num
                    for zone in @_children[i]._children
                        zone.display._mode = @display.mode.num
                        zone.display._style = @display.style.num
    
    display_suppl_context_actions: ( context_action )  ->
        context_action.push new TreeAppModule_Floors
        context_action.push new TreeAppModule_Display
   
    accept_child: ( ch ) ->
        ch instanceof FloorItem


