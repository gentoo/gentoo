# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/ibus-unikey/ibus-unikey-0.6.1.ebuild,v 1.2 2012/05/03 19:24:33 jdhore Exp $

EAPI="4"
inherit eutils

DESCRIPTION="Vietnamese Input Method Engine for IBUS using Unikey IME"
HOMEPAGE="http://code.google.com/p/ibus-unikey/"
SRC_URI="http://ibus-unikey.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk3"

RDEPEND="gtk3? ( >app-i18n/ibus-1.4.0[gtk3]
		x11-libs/gtk+:3 )
	!gtk3? ( >=app-i18n/ibus-1.4.0
		>=x11-libs/gtk+-2.12:2 )
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	>=sys-devel/gettext-0.17"

src_configure() {
	use gtk3 && myconf="--with-gtk-version=3" || myconf=""
	econf ${myconf}
}
