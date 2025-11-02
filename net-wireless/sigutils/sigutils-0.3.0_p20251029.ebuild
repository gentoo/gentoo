# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CMAKE_MAKEFILE_GENERATOR='emake'
inherit cmake

DESCRIPTION="signal processing library for blind signal analysis and automatic demodulation"
HOMEPAGE="https://github.com/BatchDrake/sigutils"
SRC_URI="https://dev.gentoo.org/~tomjbe/distfiles/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sci-libs/fftw:3.0=
	sci-libs/volk:=
	media-libs/libsndfile:=
"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply "${FILESDIR}"/${PN}-0.3.0_p20251029-drop-ldconfig.patch
	eapply_user
	cmake_src_prepare
}
