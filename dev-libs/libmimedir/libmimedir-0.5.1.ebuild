# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmimedir/libmimedir-0.5.1.ebuild,v 1.1 2012/06/15 08:37:06 ssuominen Exp $

EAPI=4
inherit eutils

DESCRIPTION="Library for manipulating MIME directory profiles (RFC2425)"
HOMEPAGE="http://sourceforge.net/projects/libmimedir/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD-2 GPL-2" # COPYING -> BSD-2, dirsynt.* -> GPL-2
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static-libs"

RDEPEND=""
DEPEND="sys-devel/bison
	sys-devel/flex"

MAKEOPTS="${MAKEOPTS} -j1"

DOCS="ChangeLog README"

src_prepare() {
	epatch "${FILESDIR}"/${P}-destdir.patch

	if ! use static-libs; then
		sed -i \
			-e '/^all/s:libmimedir.a::' \
			-e '/INSTALL.*libmimedir.a/d' \
			Makefile.in || die
	fi
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	rm -f "${ED}"/usr/lib*/*.la
}
