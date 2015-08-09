# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Lightweight HTML rendering/printing/editing engine"
HOMEPAGE="https://git.gnome.org/browse/gtkhtml"

LICENSE="GPL-2+ LGPL-2+"
SLOT="4.0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE=""

# orbit is referenced in configure, but is not used anywhere else
RDEPEND="
	>=x11-libs/gtk+-3.2:3
	>=x11-libs/cairo-1.10:=
	x11-libs/pango
	>=app-text/enchant-1.1.7:=
	gnome-base/gsettings-desktop-schemas
	>=app-text/iso-codes-0.49
	>=net-libs/libsoup-2.26.0:2.4
"
DEPEND="${RDEPEND}
	x11-proto/xproto
	sys-devel/gettext
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure --disable-static
}

src_install() {
	gnome2_src_install

	# Don't collide with 3.14 slot
	mv "${ED}"/usr/bin/gtkhtml-editor-test{,-${SLOT}} || die
}
