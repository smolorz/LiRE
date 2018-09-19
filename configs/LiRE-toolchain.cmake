set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR "i386")

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
      ${Build_LIRE_INSTALLDIR}/xenomai
      ${Build_LIRE_INSTALLDIR}/rtnet
      ${Build_LIRE_INSTALLDIR}/libraw1394
      ${Build_LIRE_INSTALLDIR}/libdc1394
      ${Build_LIRE_INSTALLDIR}/libjpeg
      ${Build_LIRE_INSTALLDIR}/libpng
      ${Build_LIRE_INSTALLDIR}/opencv
      ${Build_LIRE_INSTALLDIR}/curl
      ${Build_LIRE_INSTALLDIR}/gsl
      ${Build_LIRE_INSTALLDIR}/zlib
      ${Build_LIRE_INSTALLDIR}/libusb
      ${Build_LIRE_INSTALLDIR}/flann
      ${Build_LIRE_INSTALLDIR}/pcl
      ${Build_LIRE_INSTALLDIR}/openni
      ${Build_LIRE_INSTALLDIR}/openssl
      ${Build_LIRE_INSTALLDIR}/eigen
  )

  set(Linux_Kernel_SRC ${Build_LIRE_INSTALLDIR}/linux_scnd/src)
  execute_process(COMMAND cat ${Linux_Kernel_SRC}/.version_LIRE
                  OUTPUT_VARIABLE CMAKE_SYSTEM_VERSION
                  OUTPUT_STRIP_TRAILING_WHITESPACE)

endif(DEFINED Build_LIRE_INSTALLDIR)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

