# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Per-Face Texture Mapping for Production Rendering"
HOMEPAGE="http://ptex.us/"
SRC_URI="https://github.com/wdas/ptex/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND="sys-libs/zlib:="
DEPEND="${RDEPEND}
	app-doc/doxygen"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${P}-cxx11.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}/html"
		-DPTEX_BUILD_STATIC_LIBS=$(usex static-libs)
	)
	cmake-utils_src_configure
}
