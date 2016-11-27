# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools gnome2-utils

DESCRIPTION="Cross-desktop libraries and common resources"
HOMEPAGE="https://github.com/linuxmint/xapps/"
LICENSE="GPL-3"

SRC_URI="https://github.com/linuxmint/xapps/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

SLOT="0"
IUSE="static-libs"

RDEPEND="
	>=dev-libs/glib-2.37.3:2
	gnome-base/libgnomekbd
	gnome-base/gnome-common
	dev-libs/gobject-introspection:0=
	x11-libs/cairo
	>=x11-libs/gdk-pixbuf-2.22.0:2[introspection]
	>=x11-libs/gtk+-3.3.16:3[introspection]
	x11-libs/libxkbfile
"

DEPEND="${RDEPEND}
	"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable introspection)
}

src_install() {
	default
	rm -rf "${D}/usr/bin/" || die
	[ use static-libs ] || rm -rf "${D}/usr/lib64/libxapp.la" || die
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
