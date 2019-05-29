# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd

DESCRIPTION="Desktop integration portal"
HOMEPAGE="https://flatpak.org/ https://github.com/flatpak/xdg-desktop-portal"
SRC_URI="https://github.com/flatpak/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="doc" # geolocation

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
	sys-fs/fuse:0
"
# 	geolocation? ( >=app-misc/geoclue-2.5.2:2.0 ) # bug 678802
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -e "/^PKG_CHECK_MODULES(FLATPAK/s/^/# DONT /" -i configure.ac || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-pipewire
		--with-systemduserunitdir="$(systemd_get_userunitdir)"
		$(use_enable doc docbook-docs)
		--disable-geoclue
	)
# 		$(use_enable geolocation geoclue)
	econf "${myeconfargs[@]}"
}
