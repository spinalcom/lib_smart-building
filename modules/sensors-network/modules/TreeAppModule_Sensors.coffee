#
class TreeAppModule_Sensors extends TreeAppModule
    constructor: ->
        super()
        
        @name = 'Sensors'

        @actions.push
            txt: "Add an sensor in the building"
            fa : "fa-video-camera"
            fun: ( evt, app ) =>

#                 total_floors = 0
#                 
#                 for item in app.data.tree_items[0]._children
#                     if item instanceof BuildingItem
#                         total_floors = item._children.length

                for path in app.data.selected_tree_items
                
                    sensorsNetwork = path[ path.length - 1 ]
                    if sensorsNetwork instanceof SensorsNetworkItem 
                        
                        sensor = new SensorItem "Sensor " + sensorsNetwork._children.length
                        
                        point = app.selected_canvas_inst()[ 0 ].cm.cam.get_screen_coord [0,0]
                        sensor.basic.position.pos.set point
                        
                        # recup de la hauteur d'un etage pour adapter celle du user
                        smartBuilding = path[ path.length - 2 ]
                        if smartBuilding instanceof SmartBuildingItem
                            for ch in smartBuilding._children when ch instanceof BuildingItem
                                sensor._icon._height = ch.geometry.floor_height
                        
                        sensorsNetwork.add_output sensor
                        
                        app.data.watch_item sensor





                               
