set(CMAKE_SYSTEM_NAME Linux)

if(NOT DEFINED Build_LIRE_INSTALLDIR)
  if(DEFINED CMAKE_TOOLCHAIN_FILE)
    get_filename_component(Build_LIRE_INSTALLDIR ${CMAKE_TOOLCHAIN_FILE} DIRECTORY CACHE)
    message("Using LiRE installdir ${Build_LIRE_INSTALLDIR}")
  endif(DEFINED CMAKE_TOOLCHAIN_FILE)
endif(NOT DEFINED Build_LIRE_INSTALLDIR)

if(DEFINED Build_LIRE_INSTALLDIR)
  set(CMAKE_FIND_ROOT_PATH

      ${Build_LIRE_INSTALLDIR}/boost
      ${Build_LIRE_INSTALLDIR}/xenomai_scnd
      ${Build_LIRE_INSTALLDIR}/libjpeg
      ${Build_LIRE_INSTALLDIR}/libpng
      ${Build_LIRE_INSTALLDIR}/opencv
      ${Build_LIRE_INSTALLDIR}/curl
      ${Build_LIRE_INSTALLDIR}/zlib
      ${Build_LIRE_INSTALLDIR}/flann
      ${Build_LIRE_INSTALLDIR}/pcl
      ${Build_LIRE_INSTALLDIR}/openssl
      ${Build_LIRE_INSTALLDIR}/eigen
      ${Build_LIRE_INSTALLDIR}/libsocketcan
  )

  set(Linux_Kernel_SRC ${Build_LIRE_INSTALLDIR}/linux/src)
  set(Xenomai_Kernel_SRC ${Build_LIRE_INSTALLDIR}/linux_scnd/src)

endif(DEFINED Build_LIRE_INSTALLDIR)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

