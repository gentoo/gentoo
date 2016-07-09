# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit flag-o-matic gnome2

DESCRIPTION="C++ bindings for gtksourceview"
HOMEPAGE="https://wiki.gnome.org/Projects/GtkSourceView"

KEYWORDS="amd64 ppc x86"
IUSE="doc"
SLOT="2.0"
LICENSE="LGPL-2.1"

RDEPEND="
	>=dev-cpp/gtkmm-2.12:2.4
	dev-cpp/atkmm
	>=x11-libs/gtksourceview-2.10.0:2.0
	!>=dev-cpp/libgtksourceviewmm-1
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_prepare() {
	gnome2_src_prepare

	# Remove docs from SUBDIRS so that docs are not installed, as
	# we handle it in src_install.
	sed -i -e 's|^\(SUBDIRS =.*\)$(doc_subdirs)\(.*\)|\1\2|' Makefile.in || \
		die "sed Makefile.in failed"
}

src_configure() {
	append-cxxflags -std=c++11
	gnome2_src_configure \
		$(use_enable doc documentation) \
		--disable-static
}

src_install() {
	gnome2_src_install
	use doc && dohtml -r docs/reference/html/*
}
