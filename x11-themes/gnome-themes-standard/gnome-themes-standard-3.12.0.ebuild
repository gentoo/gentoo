# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="Standard Themes for GNOME Applications"
HOMEPAGE="https://git.gnome.org/browse/gnome-themes-standard/"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+gtk"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~x64-solaris ~x86-solaris"

COMMON_DEPEND="
	gnome-base/librsvg:2
	x11-libs/cairo
	gtk? (
		>=x11-libs/gtk+-2.24.15:2
		>=x11-libs/gtk+-3.12:3 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"
# gnome-themes{,-extras} are OBSOLETE for GNOME 3
# http://comments.gmane.org/gmane.comp.gnome.desktop/44130
# Depend on gsettings-desktop-schemas-3.4 to make sure 3.2 users don't lose
# their default background image
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gsettings-desktop-schemas-3.4
	!<x11-themes/gnome-themes-2.32.1-r1
"

src_prepare() {
	# Install cursors in the right place
	sed -e 's:^\(cursordir.*\)icons\(.*\):\1cursors/xorg-x11\2:' \
		-i themes/Adwaita/cursors/Makefile.am \
		-i themes/Adwaita/cursors/Makefile.in || die

	gnome2_src_prepare
}

src_configure() {
	# The icon cache needs to be generated in pkg_postinst()
	gnome2_src_configure \
		--disable-static \
		$(use_enable gtk gtk2-engine) \
		$(use_enable gtk gtk3-engine) \
		GTK_UPDATE_ICON_CACHE=$(type -P true)
}

src_install() {
	gnome2_src_install

	# Make it the default cursor theme
	dosym Adwaita /usr/share/cursors/xorg-x11/default
}
