# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic

DESCRIPTION="A morse daemon for the parallel or serial port"
HOMEPAGE="http://cwdaemon.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="alpha amd64 ~ppc x86"
IUSE=""

RDEPEND=">=media-radio/unixcw-3.3.1"
DEPEND="$RDEPEND
	virtual/pkgconfig"

src_configure() {
	# provides header info for getaddrinfo() with C99 (bug 569970)
	append-cppflags -D_GNU_SOURCE
	econf
}
