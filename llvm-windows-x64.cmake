# Set Windows x64 target
set (CMAKE_SYSTEM_NAME Windows)
set (CMAKE_SYSTEM_PROCESSOR x86_64)

# Use appropriate LLVM tools
set (CMAKE_C_COMPILER clang-cl)
set (CMAKE_CXX_COMPILER clang-cl)
set (CMAKE_AR llvm-lib)
set (CMAKE_LINKER lld-link-21)
set (CMAKE_MT llvm-mt)
set (CMAKE_RC_COMPILER llvm-rc)

# Pass the sysroot to the tools
set (CMAKE_C_FLAGS_INIT "-winsysroot $ENV{WINDOWS_SYSROOT_PATH}")
set (CMAKE_CXX_FLAGS_INIT "-winsysroot $ENV{WINDOWS_SYSROOT_PATH}")
set (CMAKE_EXE_LINKER_FLAGS_INIT "/winsysroot:$ENV{WINDOWS_SYSROOT_PATH}")

# Force build with /MD (otherwise clang may attempt to build with /Md, but we don't have the appropriate debug libraries. You can pass --include-debug-libs to xwin to get them, check its docs)
set (CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL")