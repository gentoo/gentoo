# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2 vala

DESCRIPTION="GLib and GObject mappings for libvirt"
HOMEPAGE="http://libvirt.org/git/?p=libvirt-glib.git"
SRC_URI="ftp://libvirt.org/libvirt/glib/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection nls +vala"
REQUIRED_USE="vala? ( introspection )"

# https://bugzilla.redhat.com/show_bug.cgi?id=1093633
RESTRICT="test"

RDEPEND="
	dev-libs/libxml2:2
	>=app-emulation/libvirt-1.2.6:=
	>=dev-libs/glib-2.38.0:2
	introspection? ( >=dev-libs/gobject-introspection-0.10.8:= )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
	vala? ( $(vala_depend) )"

src_prepare() {
	gnome2_src_prepare
	use vala && vala_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-test-coverage \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable nls) \
		$(use_enable vala)
}
