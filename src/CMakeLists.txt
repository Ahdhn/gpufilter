include_directories(${CUDA_SDK_ROOT_DIR}/common/inc)

set(CUDA_BUILD_CUBIN on)

macro(add_cuda_exec name)
  cuda_add_executable(${name} ${name}.cu)
  target_link_libraries(${name} util)
endmacro()

macro(add_cuda_exec_r name r)
  add_definitions(-DORDER=${r})
  cuda_add_executable(${name}_${r} ${name}.cu)
  target_link_libraries(${name}_${r} util)
  remove_definitions(-DORDER=${r})
endmacro()

add_cuda_exec(alg5f4)
add_cuda_exec(alg5varc)

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
