# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic autotools

DESCRIPTION="realize the collective dream of sleeping computers from all over the internet"
HOMEPAGE="http://electricsheep.org/"
SRC_URI="http://dev.gentooexperimental.org/~dreeevil/electricsheep-2.7_beta11.tar.bz2"

IUSE="" #kde gnome
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-libs/expat
	>=gnome-base/libglade-2.5.0:2.0
	>=virtual/ffmpeg-0.10
	sys-libs/zlib
	>=x11-libs/gtk+-2.7.0:2
	x11-libs/libX11"
RDEPEND="${DEPEND}
	app-arch/gzip
	media-gfx/flam3
	media-video/mplayer
	net-misc/curl
	x11-misc/xdg-utils"
#	kde? ( kde-base/kscreensaver )
#	gnome? ( gnome-extra/gnome-screensaver )
DEPEND="${DEPEND}
	virtual/pkgconfig
	x11-proto/xproto"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-xdg-utils.patch \
		"${FILESDIR}"/${PN}-gnome.patch \
		"${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${PN}-ffmpeg.patch \
		"${FILESDIR}"/${P}-ffmpeg1.patch \
		"${FILESDIR}"/${P}-ffmpeg2.patch
	eautoreconf
}

src_install() {
	emake install DESTDIR="${D}" || die "make install failed"

	# install the xscreensaver config file
	insinto /usr/share/xscreensaver/config
	doins ${PN}.xml || die "${PN}.xml failed"

	#if use kde; then
	#	set-kdedir
	#	newins ${PN}.desktop{.kde,} || die "${PN}.desktop.kde failed"
	#	insinto "${KDEDIR}/share/applnk/System/ScreenSavers"
	#	newins ${PN}.desktop{.kde,} || die "${PN}.desktop.kde failed"
	#fi

	#if use gnome; then
	#	domenu ${PN}.desktop || die "${PN}.desktop failed"
	#	exeinto /usr/libexec/gnome-screensaver
	#	doexe ${PN}-saver || die "${PN}-saver failed"
	#fi
}
