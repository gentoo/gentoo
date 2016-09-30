# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no"
PYTHON_COMPAT=( python{3_3,3_4,3_5} )
VALA_USE_DEPEND="vapigen"

inherit eutils gnome2 python-r1 vala

DESCRIPTION="Git library for GLib"
HOMEPAGE="https://wiki.gnome.org/Projects/Libgit2-glib"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="python ssh +vala"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# Specify libgit2 dependency with subslot because libgit2 upstream has a habit
# of changing their API in each release in ways that break libgit2-glib
RDEPEND="
	>=dev-libs/libgit2-0.24.0:0/24[ssh?]
	>=dev-libs/glib-2.44.0:2
	>=dev-libs/gobject-introspection-0.10.1:=
	python? (
		${PYTHON_DEPS}
		dev-python/pygobject:3[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.11
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable python) \
		$(use_enable ssh) \
		$(use_enable vala)
}

src_install() {
	gnome2_src_install

	if use python ; then
		install_gi_override() {
			python_moduleinto "$(python_get_sitedir)/gi/overrides"
			python_domodule "${S}"/${PN}/Ggit.py
		}
		python_foreach_impl install_gi_override
	fi
}
