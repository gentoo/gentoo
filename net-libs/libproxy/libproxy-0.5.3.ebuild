# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib vala

DESCRIPTION="Library for automatic proxy configuration management"
HOMEPAGE="https://github.com/libproxy/libproxy"
SRC_URI="https://github.com/libproxy/libproxy/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
IUSE="duktape gnome gtk-doc +introspection kde test vala"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=dev-libs/glib-2.71.3:2[${MULTILIB_USEDEP}]
	gnome? ( gnome-base/gsettings-desktop-schemas )
	duktape? (
		dev-lang/duktape:=
		net-misc/curl
	)
	introspection? ( dev-libs/gobject-introspection )
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	kde? ( kde-frameworks/kconfig:5 )
"
BDEPEND="
	virtual/pkgconfig
	gtk-doc? ( dev-util/gi-docgen )
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_setup
	default
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_bool gtk-doc docs)
		$(meson_use test tests)
		-Dconfig-env=true
		$(meson_use gnome config-gnome)
		-Dconfig-windows=false
		-Dconfig-sysconfig=true
		-Dconfig-osx=false
		$(meson_use kde config-kde)
		$(meson_native_use_bool duktape pacrunner-duktape)
		$(meson_native_use_bool vala vapi)
		$(meson_use duktape curl)
		$(meson_native_use_bool introspection)
	)
	meson_src_configure
}

multilib_src_install_all() {
	einstalldocs

	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/${PN}-1.0 "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}
