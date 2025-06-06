# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Library for manipulating ESRI Shapefiles"
HOMEPAGE="http://shapelib.maptools.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OSGeo/shapelib"
else
	SRC_URI="https://download.osgeo.org/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-2 LGPL-2"
SLOT="0/4"
IUSE="doc test"
RESTRICT="!test? ( test )"

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_CMAKEDIR=/usr/share/cmake/shapelib
		-DBUILD_TESTING==$( usex test )
	)

	cmake_src_configure
}

multilib_src_install() {

	local DOCS=(
		AUTHORS ChangeLog NEWS README

		$(usev doc web/.)
	)

	cmake_src_install
}
