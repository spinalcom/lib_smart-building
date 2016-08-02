#
class UserItem extends TreeItem_Parametric
    constructor: ( name = "Guy", params = {} ) ->
        super()
        
        @_name.set name
        @_viewable.set true            

        @add_attr
            basic:
                name: @_name
                position: new Point
#             mail: if params.mail? then params.mail else "unknown@mail.com"
#             phone: if params.phone? then params.phone else "+336123456780"
#             role: new Choice( 0, ["undefined","fireman","ert","extinction", "evacuation", "victim", "doctor"] )

            
        @add_attr
            _icon: new User2D @basic.position
                
        @_icon._color = new Color( Math.floor(Math.random() * 255), Math.floor(Math.random() * 255), Math.floor(Math.random() * 255), 255 )

        
        @basic.add_attr
            color: @_icon.color

    
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