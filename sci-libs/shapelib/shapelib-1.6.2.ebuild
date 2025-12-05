# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Library for manipulating ESRI Shapefiles"
HOMEPAGE="http://shapelib.maptools.org/"
SRC_URI="https://download.osgeo.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0/4"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		>=dev-cpp/benchmark-1.9.4:=
		>=dev-cpp/gtest-1.17.0:=
		)
"

PATCHES=(
	"${FILESDIR}/${PN}-1.6.2-local-test.patch"
	"${FILESDIR}/${PN}-1.6.2-gcc15.patch"
	"${FILESDIR}/${PN}-1.6.2-run-tests-in-temp-dir.patch"
)

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_CMAKEDIR=/usr/share/cmake/shapelib
		-DBUILD_TESTING=$(usex test)
		-DUSE_RPATH=OFF
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
