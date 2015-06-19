# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libspt/libspt-1.1-r2.ebuild,v 1.4 2010/03/23 20:38:04 ranger Exp $

EAPI="2"
inherit base

DESCRIPTION="Library for handling root privilege"
HOMEPAGE="http://www.j10n.org/libspt/index.html"
SRC_URI="http://www.j10n.org/libspt/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE=""

RESTRICT="test"

src_prepare() {
	epatch \
		"${FILESDIR}/libspt-werror.patch" \
		"${FILESDIR}/${P}-gentoo.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc CHANGES
}
