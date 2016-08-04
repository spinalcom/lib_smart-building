#
class PeopleItem extends TreeItem
    constructor: ( name = "People" ) ->
        super()

        @_name.set name

    
    display_suppl_context_actions: ( context_action )  ->
        context_action.push  new TreeAppModule_Users
        context_action.push  new TreeAppModule_Display

    accept_child: ( ch ) ->
        ch instanceof UserItem