# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic

DESCRIPTION="small command line tool for testing SIP applications and devices"
HOMEPAGE="https://sourceforge.net/projects/sipsak.berlios/"
SRC_URI="mirror://sourceforge/sipsak.berlios/${P/_p/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86"
IUSE="gnutls"

RDEPEND="gnutls? ( net-libs/gnutls )
	net-dns/c-ares"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P/_p1}

src_prepare() {
	epatch "${FILESDIR}/${PV}-callback.patch"
}

src_configure() {
	append-cflags -std=gnu89

	econf \
		$(use_enable gnutls)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README TODO
}
