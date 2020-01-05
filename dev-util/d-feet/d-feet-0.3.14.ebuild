# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

inherit gnome2 python-single-r1 virtualx

DESCRIPTION="D-Feet is a powerful D-Bus debugger"
HOMEPAGE="https://wiki.gnome.org/Apps/DFeet"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="test +X"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	${PYTHON_DEPS}
	>=x11-libs/gtk+-3.9.4:3[introspection]
	>=dev-libs/gobject-introspection-0.9.6:=
"
RDEPEND="
	${COMMON_DEPEND}
	>=dev-libs/glib-2.34:2
	>=dev-python/pygobject-3.3.91:3[${PYTHON_USEDEP}]
	>=sys-apps/dbus-1
	X? ( x11-libs/libwnck:3[introspection] )
"
DEPEND="
	${COMMON_DEPEND}
	dev-util/itstool
	>=dev-util/intltool-0.40.0
	test? ( dev-python/pycodestyle )
" # eautoreconf needs yelp-tools

src_configure() {
	# Tests are only python pep8 whitespace checking and intltool checks - checking python whitespate style is not useful for us
	gnome2_src_configure \
		$(use_enable test tests)
}

src_test() {
	virtx default
}
