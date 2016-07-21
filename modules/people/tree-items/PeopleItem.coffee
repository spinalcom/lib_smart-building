#
class PeopleItem extends TreeItem
    constructor: ( name = "People" ) ->
        super()

        @_name.set name
        @_viewable.set true

    
    display_suppl_context_actions: ( context_action )  ->
        context_action.push  new TreeAppModule_Users
