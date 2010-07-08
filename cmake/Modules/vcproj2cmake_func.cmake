# This vcproj2cmake-specific CMake module should be available
# at least in your root project (i.e., PROJECT/cmake/Modules/)

# Some helper functions to be used by all converted projects in the tree

# Function to automagically rebuild our converted CMakeLists.txt
# by the original converter script in case any relevant files changed.
function(v2c_rebuild_on_update _target_name _vcproj _cmakelists _script _master_proj_dir)
  # add a filter variable for someone to customize in case he/she doesn't want
  # a rebuild somewhere for some reason
  if(NOT V2C_PREVENT_AUTOMATIC_REBUILD)
    message(STATUS "${_target_name}: installing ${_cmakelists} rebuilder (watching ${_vcproj})")
    add_custom_command(OUTPUT ${_cmakelists}
      COMMAND ruby ${_script} ${_vcproj} ${_cmakelists} ${_master_proj_dir}
      # FIXME add any other relevant dependencies here
      DEPENDS ${_vcproj} ${_script}
      COMMENT "vcproj settings changed, rebuilding ${_cmakelists}"
      VERBATIM
    )

    #add_custom_target(${_target_name}_build_cmakelists VERBATIM SOURCES ${_cmakelists})
    add_custom_target(${_target_name}_build_cmakelists ALL VERBATIM SOURCES ${_cmakelists})

    # make sure the rebuild happens _before_ trying to build the actual target.
    add_dependencies(${_target_name} ${_target_name}_build_cmakelists)

# FIXME!!: we should definitely achieve aborting build process directly
# after a new CMakeLists.txt has been generated (we don't want to go
# full steam ahead with _old_ CMakeLists.txt content),
# however I don't quite know yet how to hook up those targets
# to actually get it to work.
# ok, well, in fact ideally processing should be aborted after _all_ sub projects
# have been converted, but _before_ any of these progresses towards building.
# Which is even harder to achieve, I guess... (set a marker variable
# or marker file and check for it somewhere global at the end of it all,
# then abort, that would be the idea)
#  add_custom_target(build_cmakelists_abort_build ALL
##    COMMAND /bin/false
#    COMMAND sdfgsdf
#    DEPENDS "${_cmakelists}"
#  )
#
#  add_dependencies(build_cmakelists_abort_build build_cmakelists)
  endif(NOT V2C_PREVENT_AUTOMATIC_REBUILD)
endfunction(v2c_rebuild_on_update _target_name _vcproj _cmakelists _script _master_proj_dir)