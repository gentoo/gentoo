# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-single-r1 vala

DESCRIPTION="GLib and GObject mappings for libvirt"
HOMEPAGE="http://libvirt.org/git/?p=libvirt-glib.git"
SRC_URI="ftp://libvirt.org/libvirt/glib/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+introspection python +vala"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	vala? ( introspection )
"

# https://bugzilla.redhat.com/show_bug.cgi?id=1093633
RESTRICT="test"

RDEPEND="
	dev-libs/libxml2:2
	>=app-emulation/libvirt-0.9.10:=
	>=dev-libs/glib-2.38.0:2
	introspection? ( >=dev-libs/gobject-introspection-0.10.8:= )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	gnome2_src_configure \
		--disable-test-coverage \
		--disable-static \
		$(use_enable introspection) \
		$(use_enable vala) \
		$(use_with python)
}
