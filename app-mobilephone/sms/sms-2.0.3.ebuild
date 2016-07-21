# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs eutils

DESCRIPTION="Command line program for sending SMS to Polish GSM mobile phone users"
HOMEPAGE="http://ceti.pl/~miki/komputery/sms.html"
SRC_URI="http://ceti.pl/~miki/komputery/download/sms/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""

DEPEND="sys-libs/gdbm
	dev-libs/libpcre
	dev-libs/pcre++
	net-misc/curl"

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}/${P}-gcc41.patch"
}

src_compile() {
	emake CXX=$(tc-getCXX) CXXFLAGS="${CXXFLAGS} -I./lib" LDFLAGS="-lc" || die "make failed"
}

src_install() {
	dobin sms smsaddr
	dodoc README README.smsrc Changelog doc/readme.html
	dodoc contrib/mimecut contrib/procmailrc
}
