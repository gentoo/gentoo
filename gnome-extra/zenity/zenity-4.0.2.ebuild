# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Tool to display dialogs from the commandline and shell scripts"
HOMEPAGE="https://gitlab.gnome.org/GNOME/zenity"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="man webkit"

# TODO: X11 dependency is automagically enabled
RDEPEND="
	>=gui-libs/libadwaita-1.2:1
	webkit? ( >=net-libs/webkit-gtk-2.40.1:6 )
	man? ( sys-apps/help2man )
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/itstool
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use webkit webkitgtk)
		$(meson_use man manpage)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
