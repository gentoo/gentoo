# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-single-r1

DESCRIPTION="D-Feet is a powerful D-Bus debugger"
HOMEPAGE="https://wiki.gnome.org/Apps/DFeet"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=dev-libs/glib-2.34:2
	>=dev-libs/gobject-introspection-0.9.6
	>=dev-python/pygobject-3.3.91:3[${PYTHON_USEDEP}]
	>=sys-apps/dbus-1
	>=x11-libs/gtk+-3.9.4:3[introspection]
	x11-libs/libwnck:3[introspection]
"
DEPEND="
	${PYTHON_DEPS}
	app-text/yelp-tools
	>=dev-util/intltool-0.40.0
	test? ( dev-python/pep8 )
"

src_prepare() {
	python_fix_shebang .

	# Do not run update-desktop-database (sandbox violation)
	sed -e '/^UPDATE_DESKTOP/s:=.*:=true:' \
		-i data/Makefile.am data/Makefile.in || die

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable test tests)
}
