# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libsmf/libsmf-1.3.ebuild,v 1.11 2015/03/07 08:28:15 pacho Exp $

EAPI=4

inherit autotools-utils

DESCRIPTION="Standard MIDI File format library"
HOMEPAGE="http://libsmf.sourceforge.net/api/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="doc readline static-libs"

RDEPEND=">=dev-libs/glib-2.2:2
	readline? ( sys-libs/readline )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

DOCS=( NEWS TODO )

src_configure() {
	local myeconfargs=(
		$(use_with readline)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile

	if use doc ; then
		doxygen doxygen.cfg || die
	fi
}

src_install() {
	autotools-utils_src_install
	use doc && dohtml -r api
}
