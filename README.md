# Yet Another Docker Container To Work On Windows Applications From Linux

A devcontainer configuration is provided to directly use this as a VSCode workspace.

A toolchain for CMake is provided. Pass the `--toolchain llvm-windows-x64.cmake` flag to `cmake`.

Single files may be built with `clang-cl --target=x86_64-pc-windows-msvc -winsysroot ${WINDOWS_SYSROOT_PATH} -fuse-ld=lld-link src/main.cpp`