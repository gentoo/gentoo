# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="customizable and lightweight notification-daemon"
HOMEPAGE="http://www.knopwob.org/dunst/ https://github.com/dunst-project/dunst"
SRC_URI="https://github.com/${PN}-project/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dunstify"

CDEPEND="
	dev-libs/glib:2
	dev-libs/libxdg-basedir
	sys-apps/dbus
	x11-libs/cairo[X,glib]
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2=
	x11-libs/libXScrnSaver
	x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/pango[X]
	dunstify? ( x11-libs/libnotify )
"
DEPEND="
	${CDEPEND}
	dev-lang/perl
	virtual/pkgconfig
"

RDEPEND="${CDEPEND}"

src_prepare() {
	default

	# Remove nasty CFLAGS which override user choice
	sed -i -e "/^CFLAGS/ { s:-g::;s:-O.:: }" config.mk || die

	if use dunstify; then
		# add dunstify to the all target
		sed -i -e "/^all:/ s:$: dunstify:" Makefile || die
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install

	if use dunstify; then
		dobin dunstify
	fi

	dodoc AUTHORS CHANGELOG.md README.md RELEASE_NOTES
}
