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

PATCHES=(
	"${FILESDIR}"/0002-Nullify-userdata-also-in-SASetupUtf8Hooks.patch
	"${FILESDIR}"/0004-Test-that-field-names-do-not-have-to-be-unique.patch
	"${FILESDIR}"/0010-Prefer-const-assignment-of-char.patch
	"${FILESDIR}"/0016-cmake-Add-guard-for-multiple-inclusions.patch
	"${FILESDIR}"/0018-DBFWriteAttribute-return-true-when-no-precision-loss.patch
	"${FILESDIR}"/0020-This-patch-fixes-test-running-on-Gentoo.-Perhaps-it-.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_CMAKEDIR=/usr/share/cmake/shapelib
		-DBUILD_TESTING=$(usex test)
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
