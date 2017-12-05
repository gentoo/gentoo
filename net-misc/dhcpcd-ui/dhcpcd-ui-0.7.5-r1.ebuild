# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd

DESCRIPTION="Desktop notification and configuration for dhcpcd"
HOMEPAGE="https://roy.marples.name/projects/dhcpcd-ui/"
SRC_URI="https://roy.marples.name/downloads/${PN%-ui}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug gtk gtk3 libnotify"

REQUIRED_USE="
	?? ( gtk gtk3 )
	libnotify? ( || ( gtk gtk3 ) )"

DEPEND="
	virtual/libintl
	gtk? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2
	)
	gtk3? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
	)
	libnotify? ( x11-libs/libnotify )"

RDEPEND="${DEPEND}
	>=net-misc/dhcpcd-6.4.4"

src_configure() {
	local myeconfargs=(
		--without-qt
		$(use_enable debug)
		$(usex gtk  '--with-gtk=gtk+-2.0 --with-icons' '')
		$(usex gtk3 '--with-gtk=gtk+-3.0 --with-icons' '')
		$(use_enable libnotify notification)
		$(use gtk || use gtk3 || echo '--without-icons --without-gtk')
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" INSTALL_ROOT="${D}" install

	systemd_dounit src/dhcpcd-online/dhcpcd-wait-online.service
}
