# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/xbiso/xbiso-0.6.1-r1.ebuild,v 1.2 2011/12/22 18:30:40 ssuominen Exp $

EAPI=4
inherit flag-o-matic

DESCRIPTION="Xbox xdvdfs ISO extraction utility"
HOMEPAGE="http://sourceforge.net/projects/xbiso/"
SRC_URI="mirror://sourceforge/xbiso/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="net-libs/ftplib"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e 's:C) $(CFLAGS):C) $(LDFLAGS) $(CFLAGS):' Makefile.in || die #337769
}

src_configure() {
	# for this package, interix behaves the same as BSD
	[[ ${CHOST} == *-interix* ]] && append-flags -D_BSD

	default
}

src_install() {
	dobin xbiso
	dodoc CHANGELOG README
}
