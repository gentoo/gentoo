# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/scim-tomoe/scim-tomoe-0.6.0-r2.ebuild,v 1.3 2012/05/03 19:24:28 jdhore Exp $

EAPI="2"

inherit eutils

DESCRIPTION="Japanese input method Tomoe IMEngine for SCIM"
HOMEPAGE="http://tomoe.sourceforge.net/"
SRC_URI="mirror://sourceforge/tomoe/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gucharmap"

RDEPEND=">=app-i18n/scim-1.2.0
	>=app-i18n/libtomoe-gtk-0.6.0[gucharmap=]
	gucharmap? ( >=gnome-extra/gucharmap-1.4 )
	>=x11-libs/gtk+-2.4:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.35.0"

src_prepare() {
	# Fix build with gcc-4.3, bug #
	epatch "${FILESDIR}"/${P}-gcc43.patch

	# Fix build with gucharmap-2.24, bug #243160
	epatch "${FILESDIR}/${P}-gucharmap2.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc AUTHORS ChangeLog NEWS README TODO
}
