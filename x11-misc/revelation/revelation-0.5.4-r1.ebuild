# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_9 )

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
		dev-python/pycryptodome[${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP}]
		dev-libs/libpwquality[python,${PYTHON_USEDEP}]
	')
	x11-libs/gtk+:3
	dev-libs/glib
	dev-libs/gobject-introspection
"

DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/revelation-0.5.4-issue87-fix-meson-0.60.patch )

src_prepare() {
	find -name '*.py' -exec \
		sed -i -e 's:Cryptodome:Crypto:' meson.build {} + || die
	xdg_src_prepare
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
