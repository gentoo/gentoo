# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Tool to display dialogs from the commandline and shell scripts"
HOMEPAGE="https://wiki.gnome.org/Projects/Zenity"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="webkit"

# TODO: X11 dependency is automagically enabled
RDEPEND="
	>=gui-libs/libadwaita-1.2:1
	webkit? ( >=net-libs/webkit-gtk-2.40.1:6 )

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
