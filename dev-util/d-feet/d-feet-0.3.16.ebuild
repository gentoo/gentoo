# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..9} )

inherit gnome2 meson python-single-r1 virtualx

DESCRIPTION="D-Feet is a powerful D-Bus debugger"
HOMEPAGE="https://wiki.gnome.org/Apps/DFeet"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

IUSE="test +X"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	>=x11-libs/gtk+-3.9.4:3[introspection]
	>=dev-libs/gobject-introspection-0.9.6:=
"
RDEPEND="
	${DEPEND}
	>=dev-libs/glib-2.34:2
	$(python_gen_cond_dep '
		>=dev-python/pygobject-3.3.91:3[${PYTHON_USEDEP}]
	')
	>=sys-apps/dbus-1
	X? ( x11-libs/libwnck:3[introspection] )
"
BDEPEND="
	dev-util/itstool
	test? ( dev-python/pycodestyle )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.16-fix-meson-0.61.patch
)

src_configure() {
	local emesonargs=(
		$(meson_use test tests)
		-Dpython="${EPYTHON}"
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

src_install() {
	meson_src_install
	python_optimize
}
