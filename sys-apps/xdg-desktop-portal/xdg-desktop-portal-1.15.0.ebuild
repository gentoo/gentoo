# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Desktop integration portal"
HOMEPAGE="https://flatpak.org/ https://github.com/flatpak/xdg-desktop-portal"
SRC_URI="https://github.com/flatpak/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="geolocation screencast systemd"

DEPEND="
	>=dev-libs/glib-2.66:2
	dev-libs/json-glib
	>=sys-fs/fuse-3.10.0:3[suid]
	x11-libs/gdk-pixbuf
	geolocation? ( >=app-misc/geoclue-2.5.3:2.0 )
	screencast? ( >=media-video/pipewire-0.3:= )
	systemd? ( sys-apps/systemd )
"
RDEPEND="${DEPEND}
	sys-apps/dbus
"
BDEPEND="
	dev-util/gdbus-codegen
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local myeconfargs=(
		--disable-docbook-docs # requires flatpak
		--disable-libportal # not packaged
		--with-systemduserunitdir="$(systemd_get_userunitdir)"
		$(use_enable geolocation geoclue)
		$(use_enable screencast pipewire)
		$(use_with systemd)
	)
	econf "${myeconfargs[@]}"
}
