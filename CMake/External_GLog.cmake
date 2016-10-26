if (fletch_ENABLE_GFlags)
  list(APPEND GLog_DEPENDS GFlags)
  list(APPEND GLog_EXTRA_BUILD_FLAGS
         -DWITH_GFLAGS:BOOL=ON
         -Dgflags_DIR:PATH=${fletch_BUILD_INSTALL_PREFIX}/CMake
      )
else()
  list(APPEND GLog_EXTRA_BUILD_FLAGS -DWITH_GFLAGS:BOOL=OFF)
endif()


ExternalProject_Add(GLog
  DEPENDS ${GLog_DEPENDS}
  URL ${GLog_file}
  URL_MD5 ${GLog_md5}
  PREFIX ${fletch_BUILD_PREFIX}
  DOWNLOAD_DIR ${fletch_DOWNLOAD_DIR}
  INSTALL_DIR ${fletch_BUILD_INSTALL_PREFIX}
  PATCH_COMMAND ${CMAKE_COMMAND}
    -DGLog_patch:PATH=${fletch_SOURCE_DIR}/Patches/GLog
	-DGLog_source:PATH=${fletch_BUILD_PREFIX}/src/GLog
	-P ${fletch_SOURCE_DIR}/Patches/GLog/Patch.cmake

  CMAKE_GENERATOR ${gen}
  CMAKE_ARGS
    -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
    -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DCMAKE_INSTALL_PREFIX:PATH=${fletch_BUILD_INSTALL_PREFIX}
    ${GLog_EXTRA_BUILD_FLAGS}
  )

set(GLog_ROOT ${fletch_BUILD_INSTALL_PREFIX} CACHE PATH "" FORCE)

file(APPEND ${fletch_CONFIG_INPUT} "
#######################################
# GLog
#######################################
set(GLog_ROOT @GLog_ROOT@)
")
