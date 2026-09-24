# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-build optfeature

DESCRIPTION="Virtual for OpenCL API"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv x86"

RDEPEND=">=dev-libs/opencl-icd-loader-2023.02.06[${MULTILIB_USEDEP}]"

pkg_postinst() {
	elog "In order to take advantage of OpenCL you will need a runtime for your hardware."
	elog "If any of the below descriptions match your hardware, please install them"
	elog

	optfeature_header "FOSS runtimes"
	use amd64 && {
		optfeature "integrated Intel GPUs" dev-libs/intel-compute-runtime
		optfeature "AMD GPUs supported by the amdgpu kernel driver" dev-libs/rocm-opencl-runtime
	}
	if use amd64 || use x86; then
		optfeature "generic CPU" dev-libs/pocl
	fi
	optfeature "AMD GPUs and ARM Macs" media-libs/mesa[opencl]

	optfeature_header "proprietary runtimes"
	use amd64 && optfeature "intel CPUs" dev-util/intel-ocl-sdk
	if use amd64 || use x86; then
		optfeature "AMD Polaris GPUs" dev-libs/amdgpu-pro-opencl
	fi
	if use amd64 || use  arm64 || use x86; then
		optfeature "Nvidia GPUs" x11-drivers/nvidia-drivers
		elog
		elog "Please note that for Nvidia GPUs specific package"
		elog "versions might be required for older devices."
		elog "For details please see https://www.nvidia.com/en-us/drivers/unix/legacy-gpu/"
	fi
}
