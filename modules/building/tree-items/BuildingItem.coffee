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
            geometry:
                floor_height: 4
       
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
                        
#             if @geometry.has_been_modified()
#                 for floor in @_children
#                     floor._height.set @geometry.floor_height.get()
#                     for zone in floor._children
#                         zone._height.set @geometry.floor_height.get()
                
    
    
    display_suppl_context_actions: ( context_action )  ->
        context_action.push new TreeAppModule_Floors
        context_action.push new TreeAppModule_Display
   
    accept_child: ( ch ) ->
        ch instanceof FloorItem


