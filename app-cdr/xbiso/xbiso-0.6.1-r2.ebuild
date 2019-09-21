# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils flag-o-matic

DESCRIPTION="Xbox xdvdfs ISO extraction utility"
HOMEPAGE="https://sourceforge.net/projects/xbiso/"
SRC_URI="mirror://sourceforge/xbiso/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

src_prepare() {
	sed -i -e 's:C) $(CFLAGS):C) $(LDFLAGS) $(CFLAGS):' Makefile.in || die #337769
	epatch "${FILESDIR}/${P}-libs.patch"
	mv configure.in configure.ac || die #426262
	eautoreconf
}

src_configure() {
	# for this package, interix behaves the same as BSD
	[[ ${CHOST} == *-interix* ]] && append-flags -D_BSD

	econf --disable-ftp
}

src_install() {
	dobin xbiso
	dodoc CHANGELOG README
}
