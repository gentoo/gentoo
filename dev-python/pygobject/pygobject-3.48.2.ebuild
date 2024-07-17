# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=no
PYTHON_COMPAT=( python3_{11..13} pypy3 )

inherit gnome.org meson virtualx xdg distutils-r1

DESCRIPTION="Python bindings for GObject Introspection"
HOMEPAGE="
	https://pygobject.gnome.org/
	https://gitlab.gnome.org/GNOME/pygobject/
"

LICENSE="LGPL-2.1+"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="+cairo examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.64:2
	>=dev-libs/gobject-introspection-1.64:=
	dev-libs/libffi:=
	cairo? (
		>=dev-python/pycairo-1.16.0[${PYTHON_USEDEP}]
		x11-libs/cairo[glib]
	)
"
DEPEND="
	${RDEPEND}
	test? (
		>=app-accessibility/at-spi2-core-2.46.0[introspection]
		dev-python/pytest[${PYTHON_USEDEP}]
		x11-libs/gdk-pixbuf:2[introspection,jpeg]
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection]
	)
"
BDEPEND="
	virtual/pkgconfig
"

python_configure() {
	local emesonargs=(
		$(meson_feature cairo pycairo)
		$(meson_use test tests)
		-Dpython="${EPYTHON}"
	)
	meson_src_configure
}

python_compile() {
	meson_src_compile
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	local -x GIO_USE_VFS="local" # prevents odd issues with deleting ${T}/.gvfs
	local -x GIO_USE_VOLUME_MONITOR="unix" # prevent udisks-related failures in chroots, bug #449484
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x XDG_CACHE_HOME="${T}/${EPYTHON}"
	meson_src_test --timeout-multiplier 3 || die "test failed for ${EPYTHON}"
}

python_install() {
	meson_src_install
	python_optimize
}

python_install_all() {
	distutils-r1_python_install_all
	use examples && dodoc -r examples
}
