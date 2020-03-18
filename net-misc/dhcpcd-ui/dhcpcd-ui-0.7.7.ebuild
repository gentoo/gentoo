# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="Desktop notification and configuration for dhcpcd"
HOMEPAGE="https://roy.marples.name/projects/dhcpcd-ui/"
SRC_URI="https://roy.marples.name/downloads/${PN%-ui}/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug gtk gtk2 libnotify ncurses qt5"

REQUIRED_USE="libnotify? ( gtk )
	qt5? ( !libnotify )"

BDEPEND="
	virtual/libintl
"
DEPEND="
	gtk? (
		gtk2? (
			dev-libs/glib:2
			x11-libs/gdk-pixbuf:2
			x11-libs/gtk+:2
		)
		!gtk2? (
			dev-libs/glib:2
			x11-libs/gdk-pixbuf:2
			x11-libs/gtk+:3
		)
	)
	libnotify? ( x11-libs/libnotify )
	ncurses? ( sys-libs/ncurses:0= )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		media-libs/mesa
	)
"

RDEPEND="${DEPEND}
	>=net-misc/dhcpcd-6.4.4"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.7-tinfo.patch
)

src_configure() {
	local myeconfargs=(
		--without-qt
		$(use_enable debug)
		$(use_enable libnotify notification)
		$(use_with gtk gtk $(usex gtk2 'gtk+-2.0' 'gtk+-3.0'))
		$(use_with ncurses curses)
		$(use_with qt5 qt)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" INSTALL_ROOT="${D}" install

	systemd_dounit src/dhcpcd-online/dhcpcd-wait-online.service
}
