# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-build

DESCRIPTION="Virtual for OpenCL API"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="|| ( dev-libs/ocl-icd[khronos-headers,${MULTILIB_USEDEP}]
	dev-libs/opencl-icd-loader[${MULTILIB_USEDEP}] )"

pkg_postinst() {
	elog
	elog "In order to take advantage of OpenCL you will need a runtime for your hardware."
	elog "Currently included in Gentoo are:"
	elog
	elog " * open:"
	elog "    - dev-libs/intel-neo - integrated Intel GPUs from Broadwell onwards. 64-bit only;"
	elog "    - dev-libs/rocm-opencl-runtime - AMD GPUs supported by the amdgpu kernel driver."
	elog "      Image support still requires a proprietary extension [1]. 64-bit only;"
	elog "    - media-libs/mesa[opencl] - some older AMD GPUs; see [2]. 32-bit support;"
	elog
	elog " * proprietary:"
	elog "    - dev-libs/amdgpu-pro-opencl - AMD Polaris GPUs. 32-bit support;"
	elog "    - dev-util/intel-ocl-sdk - Intel CPUs (*not* GPUs). 64-bit only;"
	elog "    - x11-drivers/nvidia-drivers[uvm] - Nvidia GPUs; specific package versions"
	elog "      required for older devices [3]. 32-bit support."
	elog
	elog " [1] dev-libs/hsa-ext-rocr"
	elog " [2] https://dri.freedesktop.org/wiki/GalliumCompute/"
	elog " [3] https://www.nvidia.com/en-us/drivers/unix/legacy-gpu/"
	elog
}
