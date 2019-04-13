# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit flag-o-matic gnome2

DESCRIPTION="ACL editor for GNOME, with Nautilus extension"
HOMEPAGE="http://rofi.roger-ferrer.org/eiciel/"
SRC_URI="http://rofi.roger-ferrer.org/eiciel/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="xattr"

RDEPEND="
	>=sys-apps/acl-2.2.32
	>=dev-cpp/gtkmm-3:3.0
	>=gnome-base/nautilus-3
	gnome-base/gvfs
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/gettext-0.18.1
"

src_configure() {
	append-cxxflags -std=c++11
	gnome2_src_configure \
		--disable-static \
		--with-gnome-version=3 \
		$(use_enable xattr user-attributes)
}
