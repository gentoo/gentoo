# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson-multilib vala

DESCRIPTION="DBus API that allows cloud storage sync clients to expose their services"
HOMEPAGE="https://gitlab.gnome.org/World/libcloudproviders"

LICENSE="LGPL-3"
SLOT="0"
IUSE="gtk-doc +introspection vala"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

DEPEND="
	>=dev-libs/glib-2.56:2[${MULTILIB_USEDEP}]
	introspection? ( dev-libs/gobject-introspection )"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	use vala && vala_setup
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_bool gtk-doc enable-gtk-doc)
		-Dinstalled-tests=false
		$(meson_native_use_bool introspection)
		$(meson_native_use_bool vala vapigen)
	)
	meson_src_configure
}

multilib_src_install() {
	meson_src_install
}
