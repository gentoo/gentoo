# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_P="${P/-/_}"

DESCRIPTION="Library for downloading files via HTTP using the GET method"
HOMEPAGE="http://http-fetcher.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~x86"
IUSE="debug"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-strict \
		$(use_enable debug)
}

src_install() {
	default
	dodoc -r docs/html/*.html docs/index.html README ChangeLog CREDITS INSTALL
}
