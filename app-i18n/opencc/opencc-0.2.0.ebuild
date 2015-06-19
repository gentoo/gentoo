# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/opencc/opencc-0.2.0.ebuild,v 1.5 2012/05/18 14:20:03 josejx Exp $

EAPI=4

inherit cmake-utils multilib

DESCRIPTION="Libraries for Simplified-Traditional Chinese Conversion"
HOMEPAGE="http://code.google.com/p/open-chinese-convert/"
SRC_URI="http://open-chinese-convert.googlecode.com/files/${P}.tar.gz"

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
