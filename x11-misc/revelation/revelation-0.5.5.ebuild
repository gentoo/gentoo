# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit gnome2-utils python-single-r1 meson xdg

DESCRIPTION="A password manager for GNOME"
HOMEPAGE="https://revelation.olasagasti.info/ https://github.com/mikelolasagasti/revelation"
SRC_URI="https://github.com/mikelolasagasti/revelation/releases/download/${P}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Upstream does not provide any test suite.
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/defusedxml[${PYTHON_USEDEP}]
		dev-python/pycryptodome[${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP}]
		dev-libs/libpwquality[python,${PYTHON_USEDEP}]
	')
	x11-libs/gtk+:3
	dev-libs/glib
	dev-libs/gobject-introspection
"

DEPEND="${RDEPEND}"

src_prepare() {
	find -name '*.py' -exec \
		sed -i -e 's:Cryptodome:Crypto:' meson.build {} + || die
	default
}

src_install() {
	meson_src_install
	python_fix_shebang "${ED}"
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
