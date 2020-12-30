# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Musical key detection library for digital audio"
HOMEPAGE="https://github.com/mixxxdj/libKeyFinder"
SRC_URI="https://github.com/mixxxdj/libKeyFinder/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sci-libs/fftw:3.0
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/libKeyFinder-${PV}

src_prepare() {
	sed -i -e "s/NAMES fftw /NAMES /" \
		cmake/FindFFTW.cmake || die
	sed -i -e "s/DESTINATION lib/DESTINATION $(get_libdir)/" \
		CMakeLists.txt || die
	cmake_src_prepare
}
