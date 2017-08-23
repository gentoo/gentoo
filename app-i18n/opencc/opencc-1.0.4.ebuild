# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils vcs-snapshot

DESCRIPTION="Libraries for conversion between Traditional and Simplified Chinese"
HOMEPAGE="https://github.com/BYVoid/OpenCC"
SRC_URI="https://github.com/BYVoid/${PN^^[oc]}/archive/ver.${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/2"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )"

DOCS="AUTHORS *.md"
PATCHES=( "${FILESDIR}"/${P}-cmake-libdir.patch )

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DBUILD_SHARED_LIBS=ON
		-DENABLE_GTEST=OFF
	)
	cmake-utils_src_configure
}
