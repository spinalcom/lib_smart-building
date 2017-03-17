#
class SensorItem extends TreeItem_Parametric
    constructor: ( name = "Sensor", params = {} ) ->
        super()
        
        @_name.set name
        @_viewable.set true            

        @add_attr
            basic:
                name: @_name
                type: new Choice( 0, [ "Thermometer", "Camera" ] )
                position: new Point
            
        @add_attr
            _icon: new Thermometer2D @basic.position
            _zone_model_id: 0
            _zone: new Ptr
                
        @_icon._color = new Color( Math.floor(Math.random() * 255), Math.floor(Math.random() * 255), Math.floor(Math.random() * 255), 255 )

        @basic.add_attr
            color: @_icon._color
 
        @bind =>
            if @basic.type.num.has_been_modified() && window?
                col = @_icon._color
                h = @_icon._height
                type = @basic.type.lst[ @basic.type.num.get() ].get() + "2D"
                @_icon = new window[type]( @basic.position )
                @_icon._color = col
                @_icon._height = h        

    # to update the position when the item is drag&drop in another ZoneItem
    update_zone: ( zoneItem ) ->
        if @_zone_model_id.get() != zoneItem.model_id
            @_zone_model_id.set zoneItem.model_id
            @basic.position.pos.set [ zoneItem.center.pos[0].get(), zoneItem.center.pos[1].get(), zoneItem._height.get()/2 ]
            # needed for apps outside is'sim
            @_zone.set(zoneItem)

    sub_canvas_items: () ->
        [ @_icon ]
    
    
    draw: ( info ) ->
        app_data = @get_app_data()
        if app_data.selected_tree_items[0]?[ app_data.selected_tree_items[0].length-1 ].model_id == @model_id
            @_icon._edge_color.r.set 255
            @_icon._edge_color.g.set 255
            @_icon._edge_color.b.set 255
        else 
            @_icon._edge_color.r.set 0
            @_icon._edge_color.g.set 0
            @_icon._edge_color.b.set 0
            
            
    is_app_data: ( item ) ->
        if item instanceof TreeAppData
            return true
        else
            return false
       
    get_app_data: ->
        it = @get_parents_that_check @is_app_data
        return it[ 0 ] 
