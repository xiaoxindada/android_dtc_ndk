#!/bin/bash
LOCALDIR=`cd "$( dirname ${BASH_SOURCE[0]} )" && pwd`

NDK_URL="https://dl.google.com/android/repository/android-ndk-r23b-linux.zip"
ZIP_NAME="NDK.zip"
setup_ndk() {
  wget "${NDK_URL}" -O "${ZIP_NAME}"
  7za x "${ZIP_NAME}"
  mv android-ndk-* ndk
}

build_extensions_file() {
 rm -rf ext
 mkdir ext
 
 for f in $(find ./jni/dtc -type f | grep -E "\.l$|\.y$"); do
   cp -f $f $LOCALDIR/ext
 done
 
 cd $LOCALDIR/ext
 for f in * ;do
   f_name=$(echo `basename $f` | sed -e "s/\.l//" -e "s/\.y//")
   if echo $f | grep -q ".l$" 2>/dev/null ;then
     flex -o ${f_name}.lex.c $f
     cp -f ${f_name}.lex.c $LOCALDIR/jni/dtc
   elif echo $f | grep -q ".y$" ;then
     bison -b $f_name -d $f
     cp -f ${f_name}.tab.c $LOCALDIR/jni/dtc
     cp -f ${f_name}.tab.h $LOCALDIR/jni/dtc/${f_name}.h
   fi
 done
# ls
 cd $LOCALDIR
}

build_with_ndk() {
  [ "$1" = "setup" ] && setup_ndk
  rm -rf obj libs
  export NDK=${LOCALDIR}/ndk
  export PATH=${NDK}:${PATH}
  build_extensions_file
  ndk-build && cd $LOCALDIR
}

build_with_cmake() {
  cp -f CMakeLists.txt jni/dtc
  rm -rf build out
  cmake -S jni/dtc -B build -DCMAKE_INSTALL_PREFIX=out
  cmake --build build -j$(nproc --all) --target install
  cd $LOCALDIR
}

if echo $@ | grep "cmake" ;then
  build_with_cmake
fi

if echo $@ | grep "ndk" ;then
  if echo $@ | grep "setup" ;then
    build_with_ndk "setup"
  else
    build_with_ndk
  fi  
fi
