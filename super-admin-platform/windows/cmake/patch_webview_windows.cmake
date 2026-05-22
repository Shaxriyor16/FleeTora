# Patches webview_windows plugin CMake for CMP0175 (invalid DEPENDS on TARGET).
set(WEBVIEW_CMAKE "${CMAKE_CURRENT_SOURCE_DIR}/flutter/ephemeral/.plugin_symlinks/webview_windows/windows/CMakeLists.txt")
if(EXISTS "${WEBVIEW_CMAKE}")
  file(READ "${WEBVIEW_CMAKE}" WEBVIEW_CONTENT)
  if(NOT WEBVIEW_CONTENT MATCHES "CMP0175")
    string(REGEX REPLACE
      "(cmake_minimum_required\\(VERSION 3\\.15\\)\r?\n)"
      "\\1if(POLICY CMP0175)\n  cmake_policy(SET CMP0175 OLD)\nendif()\n\n"
      WEBVIEW_CONTENT "${WEBVIEW_CONTENT}")
    file(WRITE "${WEBVIEW_CMAKE}" "${WEBVIEW_CONTENT}")
    message(STATUS "Patched webview_windows for CMP0175.")
  endif()
endif()
