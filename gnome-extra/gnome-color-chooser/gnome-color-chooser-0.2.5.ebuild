# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-color-chooser/gnome-color-chooser-0.2.5.ebuild,v 1.4 2014/08/10 21:19:44 slyfox Exp $

EAPI=5

inherit gnome2 flag-o-matic

DESCRIPTION="GTK+/GNOME color customization tool"
HOMEPAGE="http://gnomecc.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnomecc/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug"

RDEPEND="dev-cpp/atkmm
	>=dev-cpp/libglademm-2.6.0:2.4
	dev-cpp/glibmm:2
	>=dev-cpp/gtkmm-2.8.0:2.4
	dev-libs/glib:2
	dev-libs/libsigc++:2
	>=dev-libs/libxml2-2.6.0
	>=gnome-base/libgnome-2.16.0
	>=gnome-base/libgnomeui-2.14.0
	x11-libs/gtk+:2
	x11-libs/pango"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	# Don't pass --enable/disable-assert since it has broken
	# AC_ARG_ENABLE call. Pass -DNDEBUG to cppflags instead.
	use debug || append-cppflags -DNDEBUG

	econf \
		--disable-dependency-tracking \
		--disable-link-as-needed
}

pkg_postinst() {
	elog "To use gnome-color-chooser themes you may need to add:"
	elog "      include \".gtkrc-2.0-gnome-color-chooser\""
	elog "to ~/.gtkrc-2.0 for each user, otherwise themes may not be applied."

	gnome2_pkg_postinst
}
