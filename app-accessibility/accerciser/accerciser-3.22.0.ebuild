# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_4,3_5,3_6} )
PYTHON_REQ_USE="xml"

inherit gnome2 python-r1

DESCRIPTION="Interactive Python accessibility explorer"
HOMEPAGE="https://wiki.gnome.org/Apps/Accerciser"

LICENSE="BSD CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.5.2:2
	>=dev-python/pygobject-2.90.3:3[${PYTHON_USEDEP}]
	>=x11-libs/gtk+-3.1.13:3[introspection]

	dev-libs/atk[introspection]
	>=dev-libs/glib-2.28:2
	dev-libs/gobject-introspection:=
	>=dev-python/ipython-0.11[${PYTHON_USEDEP}]
	>=dev-python/pyatspi-2.1.5[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/libwnck:3[introspection]
	x11-libs/pango[introspection]
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	gnome2_src_prepare

	# Leave shebang alone
	sed 's:@PYTHON@:/usr/bin/python:' -i src/accerciser.in || die

	python_copy_sources
}

src_configure() {
	python_foreach_impl run_in_build_dir gnome2_src_configure
}

src_compile() {
	python_foreach_impl run_in_build_dir gnome2_src_compile
}

src_install() {
	installing() {
		gnome2_src_install
		python_doscript src/accerciser
	}
	python_foreach_impl run_in_build_dir installing
}
