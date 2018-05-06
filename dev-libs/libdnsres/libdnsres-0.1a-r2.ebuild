# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils

DESCRIPTION="A non-blocking DNS resolver library"
HOMEPAGE="https://www.monkey.org/~provos/libdnsres/"
SRC_URI="https://www.monkey.org/~provos/${P}.tar.gz"

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
