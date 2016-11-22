# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils multilib eutils vcs-snapshot

DESCRIPTION="Libraries for conversion between Traditional and Simplified Chinese"
HOMEPAGE="https://github.com/BYVoid/OpenCC"
SRC_URI="https://github.com/BYVoid/OpenCC/archive/ver.${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="doc static-libs"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

DOCS="AUTHORS NEWS.md README.md"

PATCHES=(
	"${FILESDIR}"/${P}-cmake-libdir.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DBUILD_SHARED_LIBS=ON
		-DENABLE_GTEST=OFF
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}"/usr/$(get_libdir)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	use static-libs || find "${ED}" -name '*.la' -o -name '*.a' -exec rm {} +
}
