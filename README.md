## 来自谷歌官方魔改给的安卓的dtc源码
### 如何使用:  
> apt install flex bison  
> git clone --recurse-submodules https://github.com/xiaoxindada/android_dtc_ndk.git  
> cd android_dtc_ndk  
> git pull --recurse-submodules  

 **使用ndk编译(推荐 多平台一起)**
> ./build.sh ndk setup  
>  生成物 lib,bin: obj/local/${ARCH} 最终输出: libs/${ARCH}  

**使用cmake编译**
> apt install make cmake  
> ./build.sh cmake  
> 最终输出: out  
