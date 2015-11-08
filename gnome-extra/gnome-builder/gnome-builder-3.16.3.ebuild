# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python{3_3,3_4} )

inherit gnome2 python-single-r1 virtualx

DESCRIPTION="Builder attempts to be an IDE for writing software for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Builder"

LICENSE="GPL-3+ GPL-2+ LGPL-3+ LGPL-2+ MIT CC-BY-SA-3.0 CC0-1.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+introspection"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# FIXME: some unittests seem to hang forever
RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/gjs-1.42
	>=dev-libs/glib-2.44:2
	dev-libs/libgit2[ssh,threads]
	>=dev-libs/libgit2-glib-0.22.6[ssh]
	>=dev-libs/libxml2-2.9
	dev-python/pygobject:3
	>=dev-util/devhelp-3.16
	dev-util/uncrustify
	sys-devel/clang
	>=x11-libs/gtk+-3.16.1:3[introspection?]
	>=x11-libs/gtksourceview-3.16.1:3.0[introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.42 )
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	>=dev-util/gtk-doc-am-1.11
	>=dev-util/intltool-0.50.1
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable introspection) \
		PYTHON3_CONFIG="$(python_get_PYTHON_CONFIG)"
}

src_test() {
	# FIXME: this should be handled at eclass level
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data/gsettings" || die

	GSETTINGS_SCHEMA_DIR="${S}/data/gsettings" Xemake check
}
