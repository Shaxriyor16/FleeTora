# Ensures nuget.exe is available before plugin CMake runs (webview_windows).
set(FLEETORA_NUGET_DIR "${CMAKE_CURRENT_SOURCE_DIR}/tools")
set(FLEETORA_NUGET_EXE "${FLEETORA_NUGET_DIR}/nuget.exe")
set(FLEETORA_NUGET_URL "https://dist.nuget.org/win-x86-commandline/v5.10.0/nuget.exe")
set(FLEETORA_NUGET_SHA256 "852b71cc8c8c2d40d09ea49d321ff56fd2397b9d6ea9f96e532530307bbbafd3")

file(MAKE_DIRECTORY "${FLEETORA_NUGET_DIR}")

if(NOT EXISTS "${FLEETORA_NUGET_EXE}")
  message(STATUS "Downloading NuGet to ${FLEETORA_NUGET_EXE}")
  file(DOWNLOAD "${FLEETORA_NUGET_URL}" "${FLEETORA_NUGET_EXE}" SHOW_PROGRESS)
endif()

file(SHA256 "${FLEETORA_NUGET_EXE}" FLEETORA_NUGET_HASH)
if(NOT FLEETORA_NUGET_HASH STREQUAL FLEETORA_NUGET_SHA256)
  message(FATAL_ERROR "NuGet integrity check failed for ${FLEETORA_NUGET_EXE}")
endif()

# Make find_program(NUGET nuget) succeed in webview_windows without notices.
list(PREPEND CMAKE_PROGRAM_PATH "${FLEETORA_NUGET_DIR}")
set(NUGET "${FLEETORA_NUGET_EXE}" CACHE FILEPATH "NuGet CLI" FORCE)
