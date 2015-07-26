# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/dunst/dunst-1.1.0.ebuild,v 1.2 2015/07/19 21:19:54 vikraman Exp $

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

	if use dunstify; then
		# add dunstify to the all target
		sed -ie "/^all:/ s:$: dunstify:" Makefile || die "sed failed"
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
