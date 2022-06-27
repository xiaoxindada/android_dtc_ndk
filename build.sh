#!/bin/bash
LOCALDIR=$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)

NDK_URL="https://dl.google.com/android/repository/android-ndk-r23b-linux.zip"
ZIP_NAME="NDK.zip"
setup_ndk() {
  wget "${NDK_URL}" -O "${ZIP_NAME}"
  7za x "${ZIP_NAME}"
  mv android-ndk-* ndk
}

build_extensions_file() {
  rm -rf ext
  mkdir -p ext

  for f in $(find ./jni/dtc -type f | grep -E "\.l$|\.y$"); do
    cp -f $f $LOCALDIR/ext
  done

  cd $LOCALDIR/ext
  for f in *; do
    f_name=$(echo $(basename $f) | sed -e "s/\.l//" -e "s/\.y//")
    if echo $f | grep -q ".l$" 2>/dev/null; then
      flex -o ${f_name}.lex.c $f
      cp -f ${f_name}.lex.c $LOCALDIR/jni/dtc
    elif echo $f | grep -q ".y$"; then
      bison -b $f_name -d $f
      cp -f ${f_name}.tab.c $LOCALDIR/jni/dtc
      cp -f ${f_name}.tab.h $LOCALDIR/jni/dtc/${f_name}.h
    fi
  done
  # ls
  cd $LOCALDIR
}

update_code() {
  rm -rf jni/dtc jni/libufdt
  git clone https://android.googlesource.com/platform/external/dtc jni/dtc
  [ $? != 0 ] && echo "GitHub network timeout" && exit 1
  git clone https://android.googlesource.com/platform/system/libufdt jni/libufdt
  [ $? != 0 ] && echo "GitHub network timeout" && exit 1
  cp -f jni/libufdt/sysdeps/include/libufdt_sysdeps.h jni/libufdt/libufdt_sysdeps.h
  build_extensions_file
  if [[ -d jni/dtc && -d jni/libufdt ]]; then
    rm -rf jni/dtc/.git jni/libufdt/.git
    echo "Update upstream source success"
    exit 0
  else
    echo "Update upstream source failed"
    exit 1
  fi
}

build_with_ndk() {
  [ "$1" = "setup" ] && setup_ndk
  rm -rf obj libs
  export NDK=${LOCALDIR}/ndk
  export PATH=${NDK}:${PATH}
  ndk-build && cd $LOCALDIR
}

build_with_cmake() {
  cp -f CMakeLists_dtc_tools.txt jni/dtc/CMakeLists.txt
  cp -f CMakeLists_mkdtimg.txt jni/libufdt/CMakeLists.txt
  rm -rf build dtc_tools mkdtimg out
  cmake -S jni/dtc -B dtc_tools -DCMAKE_INSTALL_PREFIX=out
  cmake --build dtc_tools -j$(nproc --all) --target install
  cmake -S jni/libufdt -B mkdtimg -DCMAKE_INSTALL_PREFIX=out
  cmake --build mkdtimg -j$(nproc --all) --target install
  cd $LOCALDIR
}

if echo $@ | grep "update_code"; then
  update_code
fi

if echo $@ | grep "cmake"; then
  build_with_cmake
fi

if echo $@ | grep "ndk"; then
  if echo $@ | grep "setup"; then
    build_with_ndk "setup"
  else
    build_with_ndk
  fi
fi
