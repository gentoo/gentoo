# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/danfis/libccd.git"
else
	SRC_URI="https://github.com/danfis/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm"
fi

DESCRIPTION="Library for collision detection between two convex shapes"
HOMEPAGE="http://libccd.danfis.cz/
	https://github.com/danfis/libccd"

LICENSE="BSD"
SLOT="0"
IUSE="+double-precision doc test"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( dev-python/sphinx )"

src_prepare() {
	# upstream issue 72
	# https://github.com/danfis/libccd/issues/72
	sed -i -e "s \${CMAKE_INSTALL_DATAROOTDIR}/doc/ccd \${CMAKE_INSTALL_DATAROOTDIR}/doc/${PF} g" \
	CMakeLists.txt doc/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc ON OFF)
		-DENABLE_DOUBLE_PRECISION=$(usex double-precision ON OFF)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use doc; then
		local DOCS=( "${BUILD_DIR}"/doc/man )
		local HTML_DOCS=( "${BUILD_DIR}"/doc/html )
		einstalldocs
	fi
}
