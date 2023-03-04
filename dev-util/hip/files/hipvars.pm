#!/usr/bin/perl -w
package hipvars;

$isWindows = 0;
$HIP_PATH='/usr';
$ROCM_PATH='/usr';
$CUDA_PATH='/opt/cuda';
$HSA_PATH='/usr';
$HIP_CLANG_PATH='@CLANG_PATH@';
$HIP_ROCCLR_HOME=$HIP_PATH;
$HIP_PLATFORM='amd';
$HIP_COMPILER = "clang";
$HIP_RUNTIME = "rocclr";
