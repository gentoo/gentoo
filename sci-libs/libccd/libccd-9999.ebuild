# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [ "${PV}" = "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/danfis/libccd/${PN}.git"
else
	SRC_URI="https://github.com/danfis/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm"
fi

DESCRIPTION="Library for collision detection between two convex shapes"
HOMEPAGE="http://libccd.danfis.cz/
	https://github.com/danfis/libccd"

LICENSE="BSD"
SLOT="0"
IUSE="+double-precision doc +shared test"
RESTRICT="!test? ( test )"

RDEPEND=""

DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc ON OFF)
		-DBUILD_SHARED_LIBS=$(usex shared ON OFF)
		-DENABLE_DOUBLE_PRECISION=$(usex double-precision ON OFF)
	)

	local CMAKE_BUILD_TYPE="Release"
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
