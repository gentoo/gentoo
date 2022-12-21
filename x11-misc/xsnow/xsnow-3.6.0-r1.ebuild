# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools xdg

DESCRIPTION="let it snow on your desktop and windows"
HOMEPAGE="https://www.ratrabbit.nl/ratrabbit/xsnow/"
SRC_URI="https://www.ratrabbit.nl/downloads/xsnow/${P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	dev-libs/glib:2
	sci-libs/gsl:=
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXpm
	x11-libs/libXtst
	x11-libs/libxkbcommon
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
PATCHES=(
	"${FILESDIR}"/${PN}-3.0.7-gamesdir.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	# Install xscreensaver hack, which calls xsnow with the correct
	# arguments. xscreensaver calls all hacks with --root, however xsnow
	# only understands -root and will exit with an error if an unknown
	# argument (--root) is provided.
	exeinto usr/$(get_libdir)/misc/xscreensaver
	newexe - xsnow <<-EOF
	#/usr/bin/env bash
	exec "${EPREFIX}/usr/bin/xsnow" -nomenu -root
EOF
}
