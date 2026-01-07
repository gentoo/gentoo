# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=libLASi-${PV}
inherit cmake

DESCRIPTION="C++ library for postscript stream output"
HOMEPAGE="https://www.unifont.org/lasi"
SRC_URI="https://downloads.sourceforge.net/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0/2"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="doc"

RDEPEND="
	dev-libs/glib:2
	media-libs/freetype:2
	x11-libs/pango"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )"

PATCHES=(
	"${FILESDIR}"/${P}-gnuinstalldirs.patch
	"${FILESDIR}"/${P}-pkgconfig.patch
	"${FILESDIR}"/${P}-gcc11.patch # bug 788766, thx to Debian
)

src_prepare() {
	cmake_src_prepare
	cmake_comment_add_subdirectory examples # bug 894062
}

src_configure() {
	local mycmakeargs=(
		-DDOXYGEN_EXECUTABLE=$(usex doc "${BROOT}"/usr/bin/doxygen '')
		-DUSE_RPATH=OFF
	)
	cmake_src_configure
}
