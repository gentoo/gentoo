# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="small command line tool for testing SIP applications and devices"
HOMEPAGE="http://sipsak.org/"
#SRC_URI="mirror://berlios/sipsak/${P/_p/-}.tar.gz"
SRC_URI="mirror://gentoo/${P/_p/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86 ~x86-fbsd"
IUSE="gnutls"

RDEPEND="gnutls? ( net-libs/gnutls )
	net-dns/c-ares"
#	ares? ( net-dns/c-ares )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P/_p1}

src_configure() {
	econf \
		$(use_enable gnutls)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
