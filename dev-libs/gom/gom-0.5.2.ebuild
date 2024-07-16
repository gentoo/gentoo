# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GCONF_DEBUG="yes"
PYTHON_COMPAT=( python3_{10..13} )

inherit gnome.org meson python-r1

DESCRIPTION="GObject to SQLite object mapper library"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gom"

LICENSE="LGPL-2+ FDL-1.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="gtk-doc +introspection python test"
RESTRICT="!test? ( test )"
REQUIRED_USE="python? ( introspection ${PYTHON_REQUIRED_USE} )"

BDEPEND="dev-build/gtk-doc-am"
RDEPEND="
	>=dev-db/sqlite-3.7:3
	>=dev-libs/glib-2.38:2
	introspection? ( >=dev-libs/gobject-introspection-1.30.0:= )
	python? ( ${PYTHON_DEPS}
		>=dev-python/pygobject-3.16:3[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	gtk-doc? ( dev-util/gi-docgen )
	virtual/pkgconfig
	test? ( x11-libs/gdk-pixbuf:2 )
"

src_prepare() {
	default
	sed -i -e '/subdir.*python/d' bindings/meson.build || die
	# drop test building and deps if not enabled
	if ! use test; then
		sed -i -e '/gdkpixbuf_dep/d' meson.build || die
		sed -i -e '/subdir(.*tests.*)/d' meson.build || die
	fi
}

src_configure() {
	local emesonargs=(
		$(meson_use introspection enable-introspection)
		$(meson_use gtk-doc enable-gtk-doc)
	)

	meson_src_configure
}

src_install() {
	docinto examples
	dodoc examples/*.py

	meson_src_install

	if use python; then
		python_foreach_impl python_domodule bindings/python/gi
	fi
}
