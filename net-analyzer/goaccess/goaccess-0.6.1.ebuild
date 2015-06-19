# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/goaccess/goaccess-0.6.1.ebuild,v 1.2 2014/11/22 12:34:41 jer Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="A real-time Apache log analyzer and interactive viewer that runs in a terminal"
HOMEPAGE="http://goaccess.prosoftcorp.com"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="geoip unicode"

RDEPEND="
	dev-libs/glib:2
	sys-libs/ncurses[unicode?]
	geoip? ( dev-libs/geoip )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-CFLAGS.patch
	"${FILESDIR}"/${P}-tinfo.patch
)

src_configure() {
	# configure does not properly recognise '--disable-something'
	local myeconfargs=(
		$(usex geoip '--enable-geoip' '' '' '')
		$(usex unicode '--enable-utf8' '' '' '')
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile CFLAGS="${CFLAGS}"
}
