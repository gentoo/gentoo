# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson-multilib vala

DESCRIPTION="DBus API that allows cloud storage sync clients to expose their services"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libcloudproviders"
LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

IUSE="gtk-doc +introspection vala"
REQUIRED_USE="vala? ( introspection )"

DEPEND="
	>=dev-libs/glib-2.64:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.82.0-r2:= )"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-build/meson-1.9.0
	>=dev-util/gdbus-codegen-2.80.5-r1
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? ( dev-util/gi-docgen )
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	use vala && vala_setup
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_bool gtk-doc documentation)
		-Dinstalled-tests=false
		$(meson_native_use_bool introspection)
		$(meson_native_use_bool vala vapigen)
	)
	meson_src_configure
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	if use gtk-doc; then
		mkdir -p "${ED}"/usr/share/gtk-doc/html/ || die
		mv "${ED}"/usr/share/doc/libcloudproviders-0.3* "${ED}"/usr/share/gtk-doc/html/ || die
	fi
}
