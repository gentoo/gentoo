# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="yes"

inherit eutils flag-o-matic gnome2

DESCRIPTION="C++ bindings for gtkglext"
HOMEPAGE="https://projects.gnome.org/gtkglext/"
SRC_URI="mirror://sourceforge/gtkglext/${P}.tar.bz2"

KEYWORDS="~amd64 ~ppc ~x86"
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
	# fix underquoted definition, bug 552686
	epatch "${FILESDIR}/${P}-aclocal.patch"

	# Remove docs from SUBDIRS so that docs are not installed, as
	# we handle it in src_install.
	sed -i -e 's|^\(SUBDIRS =.*\)docs\(.*\)|\1\2|' Makefile.in || \
		die "sed Makefile.in failed"

	gnome2_src_prepare
	append-cxxflags -std=c++11 #568024
}

src_install() {
	gnome2_src_install
	if use doc; then
		dohtml -r docs/reference/html/*
	fi
}
