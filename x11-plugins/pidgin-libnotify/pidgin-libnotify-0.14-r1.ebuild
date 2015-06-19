# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/pidgin-libnotify/pidgin-libnotify-0.14-r1.ebuild,v 1.6 2012/05/05 05:11:58 jdhore Exp $

EAPI=2
inherit eutils

DESCRIPTION="pidgin-libnotify provides popups for pidgin via a libnotify interface"
HOMEPAGE="http://gaim-libnotify.sourceforge.net/"
SRC_URI="mirror://sourceforge/gaim-libnotify/${P}.tar.gz
	mirror://debian/pool/main/p/${PN}/${PN}_${PV}-4.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls debug"

RDEPEND=">=x11-libs/libnotify-0.3.2
	net-im/pidgin[gtk]
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	EPATCH_FORCE=yes EPATCH_SUFFIX=diff epatch "${WORKDIR}"/debian/patches
	epatch "${FILESDIR}"/${P}-libnotify-0.7.patch
	sed -i -e '/CFLAGS/s:-g3::' configure || die
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable debug) \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die
	find "${D}" -name '*.la' -exec rm -f {} +
	dodoc AUTHORS ChangeLog NEWS README TODO VERSION || die
}
