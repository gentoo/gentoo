# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-build

DESCRIPTION="Virtual for OpenCL implementations"
SLOT="0"
KEYWORDS="amd64 x86"
CARDS=( amdgpu i965 nvidia )
IUSE="${CARDS[@]/#/video_cards_}"

# intel-neo and intel-ocl-sdk are amd64-only
RDEPEND="app-eselect/eselect-opencl
	|| (
		video_cards_i965? ( || (
			abi_x86_64? ( !abi_x86_32? ( dev-libs/intel-neo ) )
			dev-libs/beignet ) )
		>=media-libs/mesa-9.1.6[opencl,X(+),${MULTILIB_USEDEP}]
		video_cards_amdgpu? ( || (
			dev-libs/rocm-opencl-runtime
			dev-libs/amdgpu-pro-opencl ) )
		video_cards_nvidia? (
			>=x11-drivers/nvidia-drivers-290.10-r2[uvm] )
		abi_x86_64? ( !abi_x86_32? ( dev-util/intel-ocl-sdk ) )
	)"
