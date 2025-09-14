# Yet Another Docker Container To Work On Windows Applications From Linux

The Dockerfile for a docker container which can be used to build and run Windows applications.
A toolchain for CMake is also provided: pass the `--toolchain llvm-windows-x64.cmake` flag to `cmake`.
In addition, a devcontainer configuration is provided too.

Example using CMake:

```
cmake -S example -B build --toolchain ../llvm-windows-x64.cmake
make -C build
```

Example using the clang front-end directly:

```
mkdir -p build
clang-cl --target=x86_64-pc-windows-msvc -MD -winsysroot ${WINDOWS_SYSROOT_PATH} -fuse-ld=lld-link example/main.cpp -o build/example.exe
```

then run it with `wine build/example.exe`


## DIA SDK (TODO: automatize this)

Copy the `DIA SDK` folder from Windows to the sysroot.

In the CMakeLists you can then link your target against `diaguids`.

In order to run the application with Wine, first register the DIA SDK dll with `regsvr32 /s "${WINDOWS_SYSROOT_PATH}/DIA SDK/bin/amd64/msdia140.dll"`.