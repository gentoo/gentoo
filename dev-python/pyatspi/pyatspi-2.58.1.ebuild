# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )

inherit gnome.org meson python-r1

DESCRIPTION="Python client bindings for D-Bus AT-SPI"
HOMEPAGE="https://gitlab.gnome.org/GNOME/pyatspi2"

# Note: only some of the tests are GPL-licensed, everything else is LGPL
LICENSE="LGPL-2 GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	>=sys-apps/dbus-1
	>=dev-libs/glib-2.36.0:2
	>=app-accessibility/at-spi2-core-2.46.0[introspection]
	dev-libs/libxml2:2
	>=dev-python/pygobject-2.90.1:3[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? (
		>=dev-libs/atk-2.46.0
		dev-python/dbus-python
	)
"

src_configure() {
	python_foreach_impl run_in_build_dir \
		meson_src_configure -Denable_tests=$(usex test true false)
}

src_compile() {
	python_foreach_impl run_in_build_dir meson_src_compile
}

src_test() {
	python_foreach_impl run_in_build_dir \
		dbus-run-session meson test -C "${BUILD_DIR}" || die
}

src_install() {
	python_foreach_impl run_in_build_dir meson_src_install
	python_foreach_impl run_in_build_dir python_optimize

	einstalldocs
	docinto examples
	dodoc examples/*.py
}
