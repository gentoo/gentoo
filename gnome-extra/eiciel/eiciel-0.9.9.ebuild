# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/eiciel/eiciel-0.9.9.ebuild,v 1.3 2014/12/19 13:38:13 pacho Exp $

EAPI=5
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="ACL editor for GNOME, with Nautilus extension"
HOMEPAGE="http://rofi.roger-ferrer.org/eiciel/"
SRC_URI="http://rofi.roger-ferrer.org/eiciel/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="xattr"

RDEPEND="
	>=sys-apps/acl-2.2.32
	>=dev-cpp/gtkmm-3:3.0
	>=gnome-base/nautilus-3
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/gettext-0.18.1
"

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--with-gnome-version=3 \
		$(use_enable xattr user-attributes)
}
