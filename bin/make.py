from concat_js import *

smart_building = []

for p in os.listdir( "modules" ):
    concat_js( "modules/" + p, "gen/" + p + ".js" )
    smart_building.append("gen/" + p + ".js")

exec_cmd( "echo > smart-building.js " )

for m in sorted(smart_building):
    exec_cmd( "cat smart-building.js " + m + " > smart-building_tmp.js" )
    exec_cmd( "mv smart-building_tmp.js smart-building.js" ) 
    
exec_cmd( "cp smart-building.js ../models/" )