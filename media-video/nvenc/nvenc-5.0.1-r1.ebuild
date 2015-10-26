# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit versionator toolchain-funcs

MY_P="${PN}_${PV}_sdk"

DESCRIPTION="NVIDIA Encoder (NVENC) API"
HOMEPAGE="https://developer.nvidia.com/nvidia-video-codec-sdk"
SRC_URI="http://developer.download.nvidia.com/compute/nvenc/v$(get_version_component_range "1-2")/${MY_P}.zip"

LICENSE="NVIDIA-CODEC-SDK"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+tools samples"

RDEPEND=">=x11-drivers/nvidia-drivers-347.09
	tools? ( >=dev-util/nvidia-cuda-toolkit-6.5 )"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${MY_P}"

TOOLS="NvEncoder NvEncoderPerf NvTranscoder"

src_compile() {
	if use tools ; then
		export CUDA_PATH=/opt/cuda
		export EXTRA_LDFLAGS="${LDFLAGS}"
		for i in ${TOOLS} ; do
			pushd "${S}/Samples/${i}" || die
			emake GCC="$(tc-getCXX)" CCFLAGS="${CXXFLAGS}"
			popd
		done
	fi
}

src_install() {
	if use tools ; then
		for i in ${TOOLS}; do
			dobin "${S}/Samples/${i}/${i}"
		done
	fi

	dodoc doc/*.pdf

	if use samples ; then
		dodoc Samples/NVENC_Samples_Guide.pdf
		insinto /usr/share/${PN}
		doins -r Samples/YUV
	fi

	insinto /usr/include
	doins Samples/common/inc/nv*.h
}
