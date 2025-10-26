# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A library for using the Layer Shell Wayland protocol with GTK4."
HOMEPAGE="https://github.com/wmww/gtk4-layer-shell"
SRC_URI="https://github.com/wmww/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="examples doc test smoke-tests introspection vala"
REQUIRED_USE="vala? ( introspection )"

RESTRICT="!test? ( test )"

PYTHON_COMPAT=( python3_{11..13} )
inherit meson python-any-r1 vala

DEPEND="
	>=dev-libs/wayland-1.10.0
	>=gui-libs/gtk-4.10.5:4[wayland]
	dev-libs/glib:2
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-build/meson-0.54.0
	>=dev-build/ninja-1.8.2
	>=dev-libs/wayland-protocols-1.16
	>=dev-util/wayland-scanner-1.10.0
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2 )
	doc? ( dev-util/gtk-doc )
	test? ( >=dev-lang/python-3.8.19 )
	vala? ( dev-lang/vala[vapigen(+)] )
	smoke-tests? (
		dev-lang/luajit
		dev-lua/lgi
	)
"

pkg_setup() {
	use vala && vala_setup
}

src_configure() {
	local emesonargs=(
		$(meson_use examples)
		$(meson_use doc docs)
		$(meson_use test tests)
		$(meson_use smoke-tests)
		$(meson_use introspection)
		$(meson_use vala vapi)
	)
	meson_src_configure
}
