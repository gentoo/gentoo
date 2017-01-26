# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit versionator toolchain-funcs

MY_P="${PN}_${PV}"

DESCRIPTION="NVIDIA Video Codec SDK"
HOMEPAGE="https://developer.nvidia.com/nvidia-video-codec-sdk"
SRC_URI="https://developer.nvidia.com/video-sdk-$(replace_all_version_separators '') -> ${MY_P}.zip"

LICENSE="MIT tools? ( NVIDIA-CODEC-SDK )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tools"

RDEPEND="
	!media-video/nvenc
	>=x11-drivers/nvidia-drivers-347.09"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${MY_P}"

TOOLS="NvEncoder NvEncoderPerf NvTranscoder NvEncoderLowLatency"

src_compile() {
	if use tools ; then
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
		dodoc "${S}/Samples/NVIDIA_Video_Codec_SDK_Samples_Guide.pdf"
	fi

	dodoc doc/*.pdf ReadMe.txt Release_notes.txt

	insinto /usr/include
	doins Samples/common/inc/nvEncodeAPI.h
}
