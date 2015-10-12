# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit cmake-utils multilib

DESCRIPTION="Libraries for Simplified-Traditional Chinese Conversion"
HOMEPAGE="https://github.com/BYVoid/OpenCC"
SRC_URI="https://open-chinese-convert.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="nls static-libs"

DEPEND="nls? ( sys-devel/gettext )"
RDEPEND="nls? ( virtual/libintl )"

DOCS="AUTHORS ChangeLog README"

src_prepare() {
	sed -i \
		-e "s:\${CMAKE_\(SHARED\|STATIC\)_LIBRARY_PREFIX}:\"$(get_libdir)\":" \
		CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		"$(cmake-utils_use_enable nls GETTEXT)"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	use static-libs || find "${ED}" -name '*.la' -o -name '*.a' -exec rm {} +
}
