# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG=no
VALA_MIN_API_VERSION=0.14
VALA_USE_DEPEND=vapigen

inherit gnome2 vala

DESCRIPTION="Clutter based world map renderer"
HOMEPAGE="https://wiki.gnome.org/Projects/libchamplain"

SLOT="0.12"
LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="debug +gtk +introspection vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/glib:2
	>=media-libs/clutter-1.12:1.0[introspection?]
	media-libs/memphis:0.2[introspection?]
	media-libs/cogl:=
	>=net-libs/libsoup-2.34:2.4
	x11-libs/cairo
	gtk? (
		x11-libs/gtk+:3[introspection?]
		media-libs/clutter-gtk:1.0 )
	introspection? ( dev-libs/gobject-introspection )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"
# segfaults with vala:0.12
# vala-0.14.2-r1 required for bug #402013

src_prepare() {
	# Fix documentation slotability
	sed \
		-e "s/^DOC_MODULE.*/DOC_MODULE = ${PN}-${SLOT}/" \
		-i docs/reference/Makefile.{am,in} || die "sed (1) failed"
	sed \
		-e "s/^DOC_MODULE.*/DOC_MODULE = ${PN}-gtk-${SLOT}/" \
		-i docs/reference-gtk/Makefile.{am,in} || die "sed (2) failed"
	mv "${S}"/docs/reference/${PN}{,-${SLOT}}-docs.sgml || die "mv (1) failed"
	mv "${S}"/docs/reference-gtk/${PN}-gtk{,-${SLOT}}-docs.sgml || die "mv (2) failed"

	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# Vala demos are only built, so just disable them
	gnome2_src_configure \
		--disable-static \
		--disable-maemo \
		--disable-vala-demos \
		--enable-memphis \
		$(use_enable debug) \
		$(use_enable gtk) \
		$(use_enable introspection)
}
