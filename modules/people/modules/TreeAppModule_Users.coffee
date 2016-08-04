#
class TreeAppModule_Users extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Users'

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id

        @actions.push
            txt: "Add an user in the building"
            fa : "fa-user"
            fun: ( evt, app ) =>

                total_floors = 0
                
                for item in app.data.tree_items[0]._children
                    if item instanceof BuildingItem
                        total_floors = item._children.length

                for path in app.data.selected_tree_items
                
                    people = path[ path.length - 1 ]
                    if people instanceof PeopleItem 
                        name = prompt 'Enter the name of the user:'
                        
                        user = new UserItem name

                        point = app.selected_canvas_inst()[ 0 ].cm.cam.get_screen_coord [0,0]
                        user.basic.position.pos.set point
                        
                        # recup de la hauteur d'un etage pour adapter celle du user
                        smartBuilding = path[ path.length - 2 ]
                        if smartBuilding instanceof SmartBuildingItem
                            for ch in smartBuilding._children when ch instanceof BuildingItem
                                user._icon._height = ch.geometry.floor_height
                        
                        people.add_output user
                        
                        app.data.watch_item user





                               
