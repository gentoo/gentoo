# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/speechd-up/speechd-up-0.4-r3.ebuild,v 1.2 2009/04/01 17:35:43 williamh Exp $

IUSE=""

inherit eutils

DESCRIPTION="Interface between speakup and speech-dispatcher"
HOMEPAGE="http://www.freebsoft.org/speechd-up"
SRC_URI="http://www.freebsoft.org/pub/projects/speechd-up/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

DEPEND=">=app-accessibility/speech-dispatcher-0.6"
RDEPEND="${DEPEND}
	>=app-accessibility/speakup-3.0.2"

src_compile() {
	econf || die
	emake CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" || die
}

src_install() {
	make DESTDIR="${D}" install || die
	newinitd "${FILESDIR}"/speechd-up.rc speechd-up
	newconfd "${FILESDIR}"/speechd-up.confd speechd-up
	dodoc AUTHORS ChangeLog NEWS README TODO
	doinfo speechd-up.info
}
