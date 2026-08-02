# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
inherit meson python-any-r1 vala

DESCRIPTION="A library for using the Layer Shell Wayland protocol with GTK4"
HOMEPAGE="https://github.com/wmww/gtk4-layer-shell"
SRC_URI="https://github.com/wmww/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

IUSE="doc examples introspection +smoke-tests test vala"
REQUIRED_USE="vala? ( introspection )"

RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/wayland-1.10.0
	>=gui-libs/gtk-4.10.5:4[wayland]
	dev-libs/glib:2
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-libs/wayland-protocols-1.16
	>=dev-util/wayland-scanner-1.10.0
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2 )
	doc? ( dev-util/gtk-doc )
	vala? ( dev-lang/vala[vapigen(+)] )
	test? (
		${PYTHON_DEPS}
		examples? (
			smoke-tests? (
				dev-lang/luajit
				dev-lua/lgi
			)
		)
	)
"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	if use vala; then
		vala_setup
	else
		# Disable the vala smoke test if not built with vala
		sed '/test-vala-example/d' -i test/smoke-tests/meson.build || die
		rm test/smoke-tests/test-vala-example.py || die
	fi

	default

	use test && python_fix_shebang "${S}"
}

src_configure() {
	local emesonargs=(
		$(meson_use examples)
		$(meson_use doc docs)
		$(meson_use test tests)
		$(meson_use introspection)
		$(meson_use vala vapi)
	)
	if use test && use examples; then
		emesonargs+=( $(meson_use smoke-tests) )
	else
		emesonargs+=( -Dsmoke-tests=false )
	fi
	meson_src_configure
}
