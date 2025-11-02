# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CMAKE_MAKEFILE_GENERATOR='emake'
inherit cmake

DESCRIPTION="a realtime DSP processing library"
HOMEPAGE="https://github.com/BatchDrake/suscan"
SRC_URI="https://dev.gentoo.org/~tomjbe/distfiles/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/json-c:=
	dev-libs/libxml2:=
	media-libs/alsa-lib
	media-libs/libsndfile
	>=net-wireless/sigutils-0.3.0_p20251029
	net-wireless/soapysdr:=
	sci-libs/fftw:=
	sci-libs/volk:=
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	eapply "${FILESDIR}"/${PN}-0.3.0_p20251029-drop-ldconfig.patch
	cmake_src_prepare
}
