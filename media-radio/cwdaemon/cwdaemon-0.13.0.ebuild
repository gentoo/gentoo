# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="A morse daemon for the parallel or serial port"
HOMEPAGE="https://cwdaemon.sourceforge.net"
SRC_URI="https://github.com/acerion/${PN}/archive/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc x86"

RDEPEND=">=media-radio/unixcw-3.6.0"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	# provides header info for getaddrinfo() with C99 (bug 569970)
	append-cppflags -D_GNU_SOURCE
	econf
}
