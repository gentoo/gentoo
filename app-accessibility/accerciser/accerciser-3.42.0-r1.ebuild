# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="xml(+)"

inherit gnome2 python-single-r1

DESCRIPTION="Interactive Python accessibility explorer"
HOMEPAGE="https://wiki.gnome.org/Apps/Accerciser https://gitlab.gnome.org/GNOME/accerciser"

LICENSE="BSD CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.5.2:2
	>=x11-libs/gtk+-3.24.0:3[introspection]
	$(python_gen_cond_dep '
		>=dev-python/pygobject-2.90.3:3[${PYTHON_USEDEP}]
		>=dev-python/ipython-0.11[${PYTHON_USEDEP}]
		>=dev-python/pyatspi-2.1.5[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/python-xlib[${PYTHON_USEDEP}]
	')

	dev-libs/atk[introspection]
	>=dev-libs/glib-2.28:2
	dev-libs/gobject-introspection:=
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/libwnck:3[introspection]
	x11-libs/pango[introspection]
	gnome-base/librsvg[introspection]
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	# Port from imp to importlib (from 'master')
	"${FILESDIR}/${P}-imp-module.patch"
)

src_install() {
	gnome2_src_install
	python_optimize
}
