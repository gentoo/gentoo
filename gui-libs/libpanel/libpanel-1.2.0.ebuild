# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson vala xdg

DESCRIPTION="A dock/panel library for GTK 4"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libpanel"

LICENSE="LGPL-3+"
SLOT="1"
KEYWORDS="~amd64"

IUSE="examples gtk-doc +introspection +vala"
REQUIRED_USE="
	gtk-doc? ( introspection )
	vala? ( introspection )
"

RDEPEND="
	>=dev-libs/glib-2.75:2
	>=gui-libs/gtk-4.8:4[introspection?]
	>=gui-libs/libadwaita-1.2:1
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	gtk-doc? ( >=dev-util/gi-docgen-2021.1 )
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	use vala && vala_setup
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		$(meson_use examples install-examples)
		$(meson_feature introspection)
		$(meson_feature gtk-doc docs)
		$(meson_use vala vapi)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	if use gtk-doc; then
		mkdir "${ED}"/usr/share/gtk-doc || die
		mv "${ED}"/usr/share/doc/panel-1.0 "${ED}"/usr/share/gtk-doc/ || die
	fi
}
