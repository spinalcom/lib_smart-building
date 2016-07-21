class TreeAppModule_Users extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Users'

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm.view_id

        @actions.push
            txt: "Add an user in the building"
            ico: "img/glyphicons-7-user-add.png"
            fun: ( evt, app ) =>

                total_floors = 0
                
                for item in app.data.tree_items[0]._children
                    if item instanceof BuildingItem
                        total_floors = item._children.length

                for path in app.data.selected_tree_items
                    people = path[ path.length - 1 ]
                    if people instanceof PeopleItem 
                    
#                         names_list = [ "Jean", "Robert", "Pierre", "Paul", "Jacques", "Jeremie", "Sebastien", "Julien", "Audrey", "Clement", "Mariano", "Clemence", "Marianne", "Julie", "Andrew", "Jeromine", "Sebastienne", "Kevin", "Kevina" ]
#                         rand_name = Math.floor(Math.random() * names_list.length)
#                         rand_floor = Math.floor(Math.random() * total_floors)
#                         if rand_floor <= 4
#                             rand_space = Math.floor(Math.random() * 5)
#                         else if rand_floor == 5
#                             rand_space = Math.floor(Math.random() * 4)
#                         else
#                             rand_space = Math.floor(Math.random() * 1)
                      
                        name = prompt 'Enter the name of the user:'
                        
                        user = new UserItem name,
                            id: people._output.length
                        people.add_output user
                        
                        app.data.watch_item user





                               
