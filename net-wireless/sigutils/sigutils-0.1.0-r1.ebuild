# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CMAKE_MAKEFILE_GENERATOR='emake'
inherit cmake

DESCRIPTION="signal processing library for blind signal analysis and automatic demodulation"
HOMEPAGE="https://github.com/BatchDrake/sigutils"
SRC_URI="https://github.com/BatchDrake/sigutils/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsndfile
	sci-libs/fftw:3.0=
	sci-libs/volk:=
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	sed -i -e "s#DESTINATION lib#DESTINATION $(get_libdir)#" -e "s#/lib/#/$(get_libdir)/#" CMakeLists.txt
	sed -i "s#/lib#/$(get_libdir)#" sigutils.pc.in
	cmake_src_prepare
}
