# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils flag-o-matic

DESCRIPTION="Xbox xdvdfs ISO extraction utility"
HOMEPAGE="http://sourceforge.net/projects/xbiso/"
SRC_URI="mirror://sourceforge/xbiso/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="ftp"

RDEPEND="ftp? ( <net-libs/ftplib-4 )"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e 's:C) $(CFLAGS):C) $(LDFLAGS) $(CFLAGS):' Makefile.in || die #337769
	epatch "${FILESDIR}/${P}-libs.patch"
	mv configure.in configure.ac || die #426262
	eautoreconf
}

src_configure() {
	# for this package, interix behaves the same as BSD
	[[ ${CHOST} == *-interix* ]] && append-flags -D_BSD

	econf \
		$(use_enable ftp)
}

src_install() {
	dobin xbiso
	dodoc CHANGELOG README
}
