#
class UserItem extends TreeItem
    constructor: ( name = "Guy", params = {} ) ->
        super()
        
        @_name.set name
        @_viewable.set true            

        @add_attr
            name: @_name
            id: if params.id? then params.id else "0"
            mail: if params.mail? then params.mail else "unknown@mail.com"
            phone: if params.phone? then params.phone else "+336123456780"
            role: new Choice( 0, ["undefined","fireman","ert","extinction", "evacuation", "victim", "doctor"] )

            
        @add_attr
            position:
                floor: if params.floor? then params.floor else 0
                zone: if params.zone? then params.zone else 1
                x: new ConstrainedVal( Math.floor(Math.random() * 100) - 50, { min: -50, max: 50, div: 100 } ) 
                z: new ConstrainedVal( Math.floor(Math.random() * 100) - 50, { min: -50, max: 50, div: 100 } )   
                scale: new ConstrainedVal( 1, { min: 0, max: 2, div: 200 } )   
            
        @add_attr
            _icon: new User2D
            
        @_icon._scale = @position.scale.val
        @_icon._color = new Color( Math.floor(Math.random() * 255), Math.floor(Math.random() * 255), Math.floor(Math.random() * 255), 255 )
        @_icon._position.pos[0] = @position.x.val
        @_icon._position.pos[2] = @position.z.val
        
        @bind =>
            if @position.floor.has_been_modified()
                @_icon._position.pos[1].set @position.floor.get() * 4
            
            
    sub_canvas_items: () ->
        [ @_icon ]