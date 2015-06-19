# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/sipsak/sipsak-0.9.6_p1-r1.ebuild,v 1.1 2015/01/27 14:22:57 chainsaw Exp $

EAPI=5

inherit eutils

DESCRIPTION="small command line tool for testing SIP applications and devices"
HOMEPAGE="http://sourceforge.net/projects/sipsak.berlios/"
SRC_URI="mirror://sourceforge/sipsak.berlios/${P/_p/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="gnutls"

RDEPEND="gnutls? ( net-libs/gnutls )
	net-dns/c-ares"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P/_p1}

src_prepare() {
	epatch "${FILESDIR}/${PV}-callback.patch"
}

src_configure() {
	econf \
		$(use_enable gnutls)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
