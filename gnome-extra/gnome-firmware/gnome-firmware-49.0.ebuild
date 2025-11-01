# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson xdg

DESCRIPTION="Install firmware on devices"
HOMEPAGE="https://gitlab.gnome.org/World/gnome-firmware"
SRC_URI="https://gitlab.gnome.org/World/gnome-firmware/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64"
IUSE="+man elogind systemd"

RDEPEND="
	>=gui-libs/gtk-4.2:4
	>=dev-libs/glib-2.74.0:2
	>=sys-apps/fwupd-1.9.16:=[elogind?,systemd?]
	>=dev-libs/libxmlb-0.3.8:=
	>=gui-libs/libadwaita-1.5:1
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	man? ( sys-apps/help2man )
"

DOCS=( README.md )

src_configure() {
	local emesonargs=(
		-Dconsolekit=false
		-Ddevel=false
		$(meson_use elogind)
		$(meson_use man)
		$(meson_use systemd)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
