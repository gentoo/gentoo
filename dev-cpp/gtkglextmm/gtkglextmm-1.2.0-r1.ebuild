# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="yes"

inherit gnome2

DESCRIPTION="C++ bindings for gtkglext"
HOMEPAGE="http://projects.gnome.org/gtkglext/"
SRC_URI="mirror://sourceforge/gtkglext/${P}.tar.bz2"

KEYWORDS="amd64 ppc x86"
IUSE="doc"
SLOT="1.0"
LICENSE="GPL-2 LGPL-2.1"

RDEPEND="
	>=x11-libs/gtkglext-1
	>=dev-libs/libsigc++-2.0
	>=dev-cpp/glibmm-2.4:2
	>=dev-cpp/gtkmm-2.4:2.4
	virtual/opengl
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# Remove docs from SUBDIRS so that docs are not installed, as
	# we handle it in src_install.
	sed -i -e 's|^\(SUBDIRS =.*\)docs\(.*\)|\1\2|' Makefile.in || \
		die "sed Makefile.in failed"

	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	if use doc; then
		dohtml -r docs/reference/html/*
	fi
}
