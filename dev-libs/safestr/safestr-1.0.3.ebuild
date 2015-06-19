# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/safestr/safestr-1.0.3.ebuild,v 1.4 2010/01/15 19:47:24 ulm Exp $

DESCRIPTION="provide a standards compatible yet secure string implementation"
HOMEPAGE="http://www.zork.org/safestr/"
SRC_URI="http://www.zork.org/software/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="dev-libs/xxl"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}
	rm -rf xxl-*
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README doc/safestr.pdf
	dohtml doc/safestr.html
}
