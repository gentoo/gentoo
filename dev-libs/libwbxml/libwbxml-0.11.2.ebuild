# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Library and tools to parse, encode and handle WBXML documents"
HOMEPAGE="http://libwbxml.opensync.org/"
SRC_URI="mirror://sourceforge/libwbxml/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"

RDEPEND="
	dev-libs/expat
	virtual/libiconv
"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )
"

DOCS=( AUTHORS BUGS ChangeLog NEWS README References THANKS TODO )

src_configure() {
	local mycmakeargs=(
		-DENABLE_INSTALL_DOC=OFF
		-DENABLE_UNIT_TEST=$(usex test)
	)

	cmake-utils_src_configure
}
