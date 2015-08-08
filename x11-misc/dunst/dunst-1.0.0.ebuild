# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="customizable and lightweight notification-daemon"
HOMEPAGE="http://www.knopwob.org/dunst/"
SRC_URI="http://www.knopwob.org/public/dunst-release/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dunstify"

CDEPEND="
	dev-libs/glib:2
	dev-libs/libxdg-basedir
	sys-apps/dbus
	x11-libs/libXScrnSaver
	x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/cairo[X,glib]
	x11-libs/pango[X]
	dunstify? ( x11-libs/libnotify )
"

DEPEND="${CDEPEND}
		dev-lang/perl
		virtual/pkgconfig"

RDEPEND="${CDEPEND}"

src_prepare() {
	# Remove nasty CFLAGS which override user choice
	sed -ie "/^CFLAGS/ {
		s:-g::
		s:-O.::
	}" config.mk || die "sed failed"

	if ! use dunstify; then
		# don't build dunstify: it pulls in deps but is not being installed
		sed -ie "/^all:/ s:dunstify::" Makefile || die "sed failed"
	fi

	epatch_user
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install

	if use dunstify; then
		dobin dunstify
	fi

	dodoc CHANGELOG
}
