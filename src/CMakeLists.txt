include_directories(${CUDA_SDK_ROOT_DIR}/common/inc)

set(CUDA_BUILD_CUBIN on)

macro(add_cuda_exec name)
  file(GLOB_RECURSE UtilFiles ${CMAKE_SOURCE_DIR}/lib/util/*.*)
  cuda_add_executable(${name} ${name}.cu ${UtilFiles})
  target_link_libraries(${name} util)
endmacro()

macro(add_cuda_exec_r name r)
  add_definitions(-DORDER=${r})
  cuda_add_executable(${name}_${r} ${name}.cu)
  target_link_libraries(${name}_${r} util)
  remove_definitions(-DORDER=${r})
endmacro()

add_cuda_exec_r(alg3 1)
add_cuda_exec_r(alg3 2)
add_cuda_exec_r(alg3 3)
add_cuda_exec_r(alg3 4)
add_cuda_exec_r(alg3 5)

add_cuda_exec_r(alg4 1)
add_cuda_exec_r(alg4 2)
add_cuda_exec_r(alg4 3)
add_cuda_exec_r(alg4 4)
add_cuda_exec_r(alg4 5)

add_cuda_exec_r(alg5 1)
add_cuda_exec_r(alg5 2)
add_cuda_exec_r(alg5 3)
add_cuda_exec_r(alg5 4)
add_cuda_exec_r(alg5 5)

add_cuda_exec_r(alg6 1)
add_cuda_exec_r(alg6 2)
add_cuda_exec_r(alg6 3)
add_cuda_exec_r(alg6 4)
add_cuda_exec_r(alg6 5)

add_cuda_exec(alg5f4)
add_cuda_exec(alg5varc)
add_cuda_exec(sat)

add_definitions(-DALG5ORIG)
cuda_add_executable(alg5orig_1 alg5.cu)
target_link_libraries(alg5orig_1 util)
remove_definitions(-DALG5ORIG)

add_definitions(-DRUN_GAUSS_2)
cuda_add_executable(gauss_dir gauss_dir_fft.cu)
target_link_libraries(gauss_dir util)
remove_definitions(-DRUN_GAUSS_2)

add_definitions(-DRUN_GAUSS_FFT)
cuda_add_executable(gauss_fft gauss_dir_fft.cu)
target_link_libraries(gauss_fft util ${CUDA_cufft_LIBRARY})
remove_definitions(-DRUN_GAUSS_FFT)
