# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils eutils

MY_PN="OpenLieroX"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="Real-time excessive Worms-clone"
HOMEPAGE="http://openlierox.sourceforge.net/"
SRC_URI="mirror://sourceforge/openlierox/${MY_P}.src.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="X breakpad debug joystick"

RDEPEND="
	dev-libs/libxml2
	dev-libs/libzip:=
	media-libs/gd:=[jpeg,png]
	media-libs/libsdl[joystick?,X?]
	media-libs/sdl-image
	media-libs/sdl-mixer
	net-misc/curl
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}
	X? ( x11-proto/xproto )"

S="${WORKDIR}/${MY_PN}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.58_rc1-icu.patch
	"${FILESDIR}"/${PN}-0.58_rc1-curl.patch
	"${FILESDIR}"/${PN}-0.58_rc3-fix-c++14.patch
)

src_configure() {
	local mycmakeargs=(
		-DDEBUG=$(usex debug)
		-DX11=$(usex X)
		-DBREAKPAD=$(usex breakpad)
		-DDISABLE_JOYSTICK=$(usex !joystick)
		-DSYSTEM_DATA_DIR=usr/share
		-DVERSION=${PV}
	)
	cmake-utils_src_configure
}

src_install() {
	# NOTE: App uses case-insensitive file-handling
	dobin "${CMAKE_BUILD_DIR}"/bin/openlierox

	insinto /usr/share/${PN}
	doins -r share/gamedir/.

	DOCS=( doc/{README,ChangeLog,Development,TODO,original_lx_docs/*.txt} )
	HTML_DOCS=( doc/original_lx_docs/{*.html,images} )
	einstalldocs

	doicon share/OpenLieroX.*
	make_desktop_entry openlierox OpenLieroX OpenLieroX \
			"Game;ActionGame;ArcadeGame;"
}
