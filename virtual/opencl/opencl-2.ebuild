# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-build

DESCRIPTION="Virtual for OpenCL implementations"
SLOT="0"
KEYWORDS="amd64 x86"
CARDS=( amdgpu i965 nvidia r600 radeonsi )
IUSE="${CARDS[@]/#/video_cards_}"

# intel-neo, intel-ocl-sdk and rocm-opencl-runtime are abi_x86_64-only
# ocl-icd is essentially a dummy/you-are-on-your-own provider - it installs
# header files to include in the source code and a library to link against
# but does not support any actual devices
RDEPEND="app-eselect/eselect-opencl
	|| (
		video_cards_i965? (
			abi_x86_64? ( !abi_x86_32? ( dev-libs/intel-neo ) )
		)
		video_cards_amdgpu? ( || (
			abi_x86_64? ( !abi_x86_32? ( dev-libs/rocm-opencl-runtime ) )
			dev-libs/amdgpu-pro-opencl[${MULTILIB_USEDEP}] ) )
		video_cards_nvidia? ( || (
			>=x11-drivers/nvidia-drivers-290.10-r2[uvm(-)]
			>=media-libs/mesa-9.1.6[opencl,X(+),${MULTILIB_USEDEP}] ) )
		video_cards_r600? (
			>=media-libs/mesa-9.1.6[opencl,X(+),${MULTILIB_USEDEP}] )
		video_cards_radeonsi? (
			>=media-libs/mesa-9.1.6[opencl,X(+),${MULTILIB_USEDEP}] )
		abi_x86_64? ( !abi_x86_32? ( dev-util/intel-ocl-sdk ) )
		dev-libs/ocl-icd[khronos-headers,${MULTILIB_USEDEP}]
	)"
