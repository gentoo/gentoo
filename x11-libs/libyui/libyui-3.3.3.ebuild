# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="UI abstraction library"
HOMEPAGE="https://github.com/libyui/libyui"
SRC_URI="https://github.com/libyui/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/6"
KEYWORDS="~amd64 ~x86"
IUSE="gtk ncurses qt5 static-libs"

# Only Boost headers are needed
DEPEND="dev-libs/boost"
PDEPEND="
	gtk? ( x11-libs/libyui-gtk:${SLOT} )
	ncurses? ( x11-libs/libyui-ncurses:${SLOT} )
	qt5? ( x11-libs/libyui-qt:${SLOT} )
"

REQUIRED_USE="|| ( gtk ncurses qt5 )"

src_prepare() {
	cp buildtools/CMakeLists.common CMakeLists.txt || die

	# TODO: set proper docs deps and USE flag for building them
	sed -i -e '/SET_AUTODOCS/d' CMakeLists.txt || die 'sed on CMakeLists.txt failed'
	sed -i -e 's/src examples/src/' PROJECTINFO.cmake || die 'sed on PROJECTINFO.cmake failed'

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DDOC_DIR="${EPREFIX}/usr/share/doc/${PF}"
		-DENABLE_STATIC=$(usex static-libs)
		-DENABLE_WERROR=OFF
		-DRESPECT_FLAGS=ON
	)
	cmake-utils_src_configure
}
