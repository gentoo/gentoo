# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="small command line tool for testing SIP applications and devices"
HOMEPAGE="https://github.com/nils-ohlmeier/sipsak"
SRC_URI="https://github.com/nils-ohlmeier/sipsak/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="net-libs/gnutls
	net-dns/c-ares"
DEPEND="${RDEPEND}"

src_configure() {
	append-cflags -std=gnu89 -fcommon
	econf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README TODO
}
