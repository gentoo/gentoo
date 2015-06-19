# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libdnsres/libdnsres-0.1a-r2.ebuild,v 1.6 2014/07/10 18:47:49 jer Exp $

EAPI=5

inherit autotools eutils

DESCRIPTION="A non-blocking DNS resolver library"
HOMEPAGE="http://www.monkey.org/~provos/libdnsres/"
SRC_URI="http://www.monkey.org/~provos/${P}.tar.gz"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

DEPEND="dev-libs/libevent"
RDEPEND="${DEPEND}"

DOCS=( README )

src_prepare() {
	epatch "${FILESDIR}/${P}-autotools.patch"
	sed -i configure.in -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' || die
	eautoreconf
}
