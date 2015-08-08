# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit gnome2 eutils

DESCRIPTION="A widget toolkit using Clutter"
HOMEPAGE="http://clutter-project.org/"
SRC_URI="mirror://github/clutter-project/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="1.0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="dbus debug glade +gtk +introspection startup-notification"

RDEPEND="
	>=dev-libs/glib-2.28.0:2
	>=media-libs/clutter-1.7.91:1.0
	media-libs/cogl:=
	>=x11-apps/xrandr-1.2.0

	x11-libs/gdk-pixbuf:2[introspection?]

	dbus? ( >=dev-libs/dbus-glib-0.82 )
	glade? (
		>=dev-util/glade-3.4.5:3
		<dev-util/glade-3.9.1:3 )
	gtk? ( >=x11-libs/gtk+-2.20:2[introspection?] )
	introspection? ( >=dev-libs/gobject-introspection-0.6.4 )
	startup-notification? ( >=x11-libs/startup-notification-0.9 )
"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	# Tests are interactive, no use for us
	sed -e 's/^\(SUBDIRS .*\)tests\(.*\)/\1 \2/g' \
		-i Makefile.am -i Makefile.in || die
	# In 1.4.8
	epatch "${FILESDIR}/${P}-gl-types.patch"

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--with-winsys=x11 \
		$(use_enable gtk gtk-widgets) \
		$(use_enable introspection) \
		$(use_enable debug) \
		$(use_with dbus) \
		$(use_with glade) \
		$(use_with startup-notification)
}
