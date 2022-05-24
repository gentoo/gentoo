# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Cross-platform access library for Intel CSME HECI interface"
HOMEPAGE="https://github.com/intel/metee"
SRC_URI="https://github.com/intel/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/3.1.3"
KEYWORDS="amd64"
IUSE="doc"

BDEPEND="doc? ( app-doc/doxygen )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS="$(usex doc)"
		-DBUILD_SAMPLES="NO"
		-DBUILD_SHARED_LIBS="YES"
		-DBUILD_TEST="NO"
		-DCONSOLE_OUTPUT="NO"
	)

	cmake_src_configure
}
