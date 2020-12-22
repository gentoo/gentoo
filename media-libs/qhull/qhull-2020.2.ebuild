# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Geometry library"
HOMEPAGE="http://www.qhull.org"
SRC_URI="https://github.com/qhull/qhull/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc static-libs"

DOCS=( Announce.txt File_id.diz README.txt REGISTER.txt )

src_prepare() {
	if ! use doc ; then
		sed -i \
			-e '/^install(DIRECTORY html/d' \
			-e '/^[[:blank:]]*index.htm/d' \
			CMakeLists.txt || die
	fi

	cmake_src_prepare
}

src_configure() {
	CMAKE_BUILD_TYPE=Release

	mycmakeargs+=(
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DDOC_INSTALL_DIR="${EPREFIX}"/usr/share/doc/${PF}
		-DLIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)"
	)
	cmake_src_configure
}
