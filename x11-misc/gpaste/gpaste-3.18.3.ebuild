# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

VALA_USE_DEPEND="vapigen"

inherit eutils autotools gnome2-utils vala vcs-snapshot

DESCRIPTION="Clipboard management system"
HOMEPAGE="https://github.com/Keruspe/GPaste"
SRC_URI="https://github.com/Keruspe/GPaste/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+applet gnome vala"

CDEPEND="
	dev-libs/appstream-glib
	>=dev-libs/glib-2.46:2
	>=dev-libs/gobject-introspection-1.46.0
	sys-apps/dbus
	>=x11-libs/gdk-pixbuf-2.32:2
	>=x11-libs/gtk+-3.18:3
	x11-libs/libX11
	x11-libs/libXi
	gnome? (
		gnome-base/gnome-control-center:2
		media-libs/clutter
		x11-libs/pango
	)
"
RDEPEND="${CDEPEND}
	gnome? (
		gnome-base/gnome-shell
	)
"
DEPEND="${CDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	eautoreconf
	intltoolize --force --automake || die "intltoolize error"
	vala_src_prepare

	if ! use gnome ; then
		echo "" > data/control-center.mk || die
	fi
}

src_configure() {
	econf \
		$(use_enable vala) \
		$(use_enable applet) \
		--disable-unity \
		$(use_enable gnome gnome-shell-extension) \
		--disable-static \
		--disable-schemas-compile
}

src_install() {
	default
	prune_libtool_files
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
