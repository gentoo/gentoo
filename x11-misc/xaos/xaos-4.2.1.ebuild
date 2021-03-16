# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Very fast real-time fractal zoomer"
HOMEPAGE="https://xaos-project.github.io/"
SRC_URI="https://github.com/${PN}-project/XaoS/archive/release-${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~jlec/distfiles/${PN}.png.tar"
S="${WORKDIR}/XaoS-release-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="aalib doc png threads X"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	sci-libs/gsl:0=
	sys-libs/zlib
	aalib? ( media-libs/aalib )
	png? ( media-libs/libpng:0= )
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXxf86vm
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
	doc? ( virtual/texi2dvi )
	X? ( x11-base/xorg-proto )
"

# PATCHES=( "${FILESDIR}"/${PN}-3.4-include.patch )

src_prepare() {
	cp "${FILESDIR}"/${P}-CMakeLists.txt ./CMakeLists.txt || die
	cmake_src_prepare
}
