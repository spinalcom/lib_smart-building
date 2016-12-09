from concat_js import *

exec_cmd_silent( "echo \"\" > models.js " )
exec_cmd_silent( "echo \"\" > processes.js " )
exec_cmd_silent( "mkdir -p dist " )


for p in os.listdir( "modules" ):
    exec_cmd_silent( "echo \"\" > dist/" + p + ".js " )
    ##########
    # models #
    ##########
    if os.path.isfile(  "modules/" + p + "/models" ):
        concat_js( "modules/" + p + "/models", "dist/models." + p + ".js" )
        if os.path.isfile( "dist/models." + p + ".js" ):
            exec_cmd_silent( "cat dist/models." + p + ".js >> models.js" )
            exec_cmd_silent( "cat dist/models." + p + ".js >> dist/" + p + ".js " )
    #############
    # processes #
    #############
    if os.path.isfile( "modules/" + p + "/processes" ):
        concat_js( "modules/" + p + "/processes", "dist/processes." + p + ".js" )
        if os.path.isfile( "dist/processes." + p + ".js" ):
            exec_cmd_silent( "cat dist/processes." + p + ".js >> processes.js" )
            exec_cmd_silent( "cat dist/processes." + p + ".js >> dist/" + p + ".js " )

##########
# is-sim #
##########
concat_js( "modules/", "is-sim.js" )
exec_cmd_silent( "cat config.js >> is-sim.js " )
