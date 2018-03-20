# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils systemd

DESCRIPTION="Desktop notification and configuration for dhcpcd"
HOMEPAGE="https://roy.marples.name/projects/dhcpcd-ui"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/rsmarples/dhcpcd-ui"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://roy.marples.name/downloads/${PN%-ui}/${P}.tar.bz2"
	KEYWORDS="amd64 x86"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE="debug gtk gtk3 libnotify ncurses qt5"

REQUIRED_USE="
	|| ( gtk gtk3 ncurses qt5 )
	?? ( gtk gtk3 qt5 )
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
	ncurses? (
		sys-libs/ncurses:0
	)
	qt5? (
		dev-qt/qtgui:5
		dev-qt/qtcore:5
		dev-qt/qtwidgets:5
	)
	libnotify? ( x11-libs/libnotify )"

RDEPEND="${DEPEND}
	>=net-misc/dhcpcd-6.4.4"

src_prepare() {
	default

	# force qt5 compilation
	if use qt5; then
		export QT_SELECT=qt5
		sed -e '/^desktop\.path/s:\$\$SYSCONFDIR/xdg/autostart:\$\$PREFIX/share/applications:' \
		-i "${S}"/src/dhcpcd-qt/dhcpcd-qt.pro || die
	fi

	# patch for ncurses[tinfo] see #457530
	if use ncurses ; then
		sed -i 's/LIB_CURSES=-lcurses/LIB_CURSES=`pkg-config --libs ncurses`/' "${S}/configure" || die "sed failed"
	fi
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(usex gtk  '--with-gtk=gtk+-2.0 --with-icons' '')
		$(usex gtk3 '--with-gtk=gtk+-3.0 --with-icons' '')
		$(usex ncurses '--with-curses' '--without-curses')
		$(usex qt5 '--with-qt --with-icons' '--without-qt')
		$(use_enable libnotify notification)
		$(use gtk || use gtk3 || echo '--without-gtk')
		$(use gtk || use gtk3 || use qt5 || echo '--without-icons')
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" INSTALL_ROOT="${D}" install

	systemd_dounit src/dhcpcd-online/dhcpcd-wait-online.service
}
