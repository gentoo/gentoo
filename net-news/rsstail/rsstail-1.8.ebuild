# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/rsstail/rsstail-1.8.ebuild,v 1.3 2012/03/08 09:11:55 phajdan.jr Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="A tail-like RSS-reader"
HOMEPAGE="http://www.vanheusden.com/rsstail/"
SRC_URI="http://www.vanheusden.com/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=net-libs/libmrss-0.17.1"
RDEPEND="${DEPEND}"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -DVERSION=\\\"\$(VERSION)\\\"" \
		LDFLAGS="${LDFLAGS} -lmrss"
}

src_install() {
	dobin rsstail
	doman rsstail.1
	newdoc readme.txt README
}
