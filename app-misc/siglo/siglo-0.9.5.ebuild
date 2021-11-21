# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_9 )
inherit gnome2-utils python-single-r1 meson xdg

DESCRIPTION="GTK app to sync InfiniTime watch with PinePhone"
HOMEPAGE="https://github.com/alexr4535/siglo"
SRC_URI="https://github.com/alexr4535/siglo/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
DEPEND=""
RDEPEND="${DEPEND}
		$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/gatt-python[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}]
		')"
BDEPEND="${PYTHON_DEPS}"

#tests seem to fail
RESTRICT="test"

src_configure() {
	python_setup
	sed -i "s#python.find_installation('python3').path()#\'${EPYTHON}\'#" src/meson.build
	meson_src_configure
}

src_install() {
	meson_src_install
	python_fix_shebang "${ED}/usr/bin"
	python_optimize
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
