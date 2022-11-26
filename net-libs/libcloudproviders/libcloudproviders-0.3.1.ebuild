# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson vala

DESCRIPTION="DBus API that allows cloud storage sync clients to expose their services"
HOMEPAGE="https://gitlab.gnome.org/World/libcloudproviders"

LICENSE="LGPL-3"
SLOT="0"
IUSE="gtk-doc +introspection vala"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

DEPEND=">=dev-libs/glib-2.51.2:2
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

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc enable-gtk-doc)
		-Dinstalled-tests=false
		$(meson_use introspection)
		$(meson_use vala vapigen)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
}
