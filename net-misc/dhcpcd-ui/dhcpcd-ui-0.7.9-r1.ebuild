# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd toolchain-funcs xdg

DESCRIPTION="Desktop notification and configuration for dhcpcd"
HOMEPAGE="https://github.com/NetworkConfiguration/dhcpcd-ui https://roy.marples.name/projects/dhcpcd-ui/"
SRC_URI="https://github.com/NetworkConfiguration/dhcpcd-ui/releases/download/v${PV}/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug gtk libnotify ncurses"

REQUIRED_USE="libnotify? ( gtk )"

BDEPEND="
	media-gfx/cairosvg
	virtual/libintl
"
DEPEND="
	gtk? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
	)
	libnotify? ( x11-libs/libnotify )
	ncurses? ( sys-libs/ncurses:= )
"
RDEPEND="${DEPEND}
	>=net-misc/dhcpcd-6.4.4
"

src_configure() {
	local myeconfargs=(
		--without-qt
		--without-qt5 # bug #956450
		$(use_enable debug)
		$(use_enable libnotify notification)
		$(use_with gtk gtk 'gtk+-3.0')
		$(use_with ncurses curses)
	)

	tc-export AR CC CXX

	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" INSTALL_ROOT="${D}" install
	systemd_dounit src/dhcpcd-online/dhcpcd-wait-online.service
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
