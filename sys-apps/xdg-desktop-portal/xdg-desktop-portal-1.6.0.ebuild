# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd

DESCRIPTION="Desktop integration portal"
HOMEPAGE="https://flatpak.org/ https://github.com/flatpak/xdg-desktop-portal"
SRC_URI="https://github.com/flatpak/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="doc geolocation screencast"

BDEPEND="
	dev-util/gdbus-codegen
	sys-devel/gettext
	virtual/pkgconfig
	doc? (
		app-text/xmlto
		app-text/docbook-xml-dtd:4.3
	)
"
DEPEND="
	dev-libs/glib:2[dbus]
	dev-libs/json-glib
	media-libs/fontconfig
	sys-fs/fuse:0
	geolocation? ( >=app-misc/geoclue-2.5.3:2.0 )
	screencast? ( media-video/pipewire:= )
"
RDEPEND="${DEPEND}"

src_configure() {
	local myeconfargs=(
		--with-systemduserunitdir="$(systemd_get_userunitdir)"
		$(use_enable doc docbook-docs)
		$(use_enable geolocation geoclue)
		$(use_enable screencast pipewire)
		--disable-libportal # not packaged
		--disable-geoclue
	)
	econf "${myeconfargs[@]}"
}
