# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-single-r1 virtualx

DESCRIPTION="D-Feet is a powerful D-Bus debugger"
HOMEPAGE="https://wiki.gnome.org/Apps/DFeet"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=dev-libs/glib-2.34:2
	>=dev-libs/gobject-introspection-0.9.6:=
	>=dev-python/pygobject-3.3.91:3[${PYTHON_USEDEP}]
	>=sys-apps/dbus-1
	>=x11-libs/gtk+-3.9.4:3[introspection]
	x11-libs/libwnck:3[introspection]
"
DEPEND="${PYTHON_DEPS}
	app-text/yelp-tools
	>=dev-util/intltool-0.40.0
"

src_prepare() {
	python_fix_shebang .

	# Do not run update-desktop-database (sandbox violation)
	sed -e '/^UPDATE_DESKTOP/s:=.*:=true:' \
		-i data/Makefile.am data/Makefile.in || die

	# disable pep8 - checking python whitespace style is not useful for us
	sed -e 's/pep8 /# pep8 /' \
		-i src/tests/Makefile.am src/tests/Makefile.in || die

	gnome2_src_prepare
}

src_configure() {
	# disable pep8 - checking python code style is not useful downstream
	# (especially when that style check fails!)
	gnome2_src_configure \
		$(use_enable test tests) \
		PEP8=$(type -P true)
}

src_test() {
	virtx emake check
}
