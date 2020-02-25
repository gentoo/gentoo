# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GCONF_DEBUG="yes"
PYTHON_COMPAT=( python3_{6,7} )

inherit gnome.org gnome2-utils meson python-r1

DESCRIPTION="GObject to SQLite object mapper library"
HOMEPAGE="https://wiki.gnome.org/Projects/Gom"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="gtk-doc +introspection test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=dev-db/sqlite-3.7:3
	>=dev-libs/glib-2.36:2
	introspection? ( >=dev-libs/gobject-introspection-1.30.0:= )
	${PYTHON_DEPS}
	>=dev-python/pygobject-3.16:3[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	gtk-doc? ( dev-util/gtk-doc )
	virtual/pkgconfig
	x11-libs/gdk-pixbuf:2
" # only tests need gdk-pixbuf, but they are unconditionally built

pkg_setup() {
	python_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use introspection enable-introspection)
		$(meson_use gtk-doc enable-gtk-doc)
	)

	python_foreach_impl meson_src_configure
}

src_compile() {
	python_foreach_impl meson_src_compile
}

src_install() {
	docinto examples
	dodoc examples/*.py

	installing() {
		meson_src_install
		python_optimize
	}
	python_foreach_impl installing
}

src_test() {
	# tests may take a long time
	python_foreach_impl meson_src_test
}
