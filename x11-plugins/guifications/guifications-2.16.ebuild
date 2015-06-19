# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/guifications/guifications-2.16.ebuild,v 1.11 2012/05/05 05:12:02 jdhore Exp $

EAPI="2"

inherit eutils

MY_PN=pidgin-${PN}
MY_PV=${PV/_beta/beta}
MY_P=${MY_PN}-${MY_PV}
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Guifications is a graphical notification plugin for the open source instant message client pidgin"
HOMEPAGE="http://plugins.guifications.org/"
SRC_URI="http://downloads.guifications.org/plugins//Guifications2/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc sparc x86"
IUSE="debug nls"

RDEPEND="net-im/pidgin[gtk]
	x11-libs/gtk+:2"

DEPEND="${DEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable debug ) \
		$(use_enable nls) || die "econf failure"
}

src_install() {
	emake install DESTDIR="${D}" || die "make install failure"
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO VERSION || die
}
