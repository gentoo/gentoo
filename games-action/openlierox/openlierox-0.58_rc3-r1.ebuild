# Copyright 1999-2016 Gentoo Foundation
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
KEYWORDS="~amd64 ~x86"
IUSE="X breakpad debug joystick"

RDEPEND="media-libs/sdl-mixer
	media-libs/sdl-image
	media-libs/gd[jpeg,png]
	dev-libs/libxml2
	dev-libs/libzip
	net-misc/curl
	joystick? ( media-libs/libsdl[joystick] )
	!joystick? ( media-libs/libsdl )
	X? ( x11-libs/libX11
		media-libs/libsdl[X] )
	!X? ( media-libs/libsdl )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.58_rc1-icu.patch \
			"${FILESDIR}"/${PN}-0.58_rc1-curl.patch
	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-D DEBUG=$(usex debug)
		-D X11=$(usex X)
		-D BREAKPAD=$(usex breakpad Yes No)
		-D DISABLE_JOYSTICK=$(usex joystick No Yes)
		-D SYSTEM_DATA_DIR=/usr/share
		-D VERSION=${PV}
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	# NOTE: App uses case-insensitive file-handling
	insinto /usr/share/${PN}/
	doins -r share/gamedir/*

	dodoc doc/{README,ChangeLog,Development,TODO}
	insinto /usr/share/doc/"${PF}"
	doins -r doc/original_lx_docs

	doicon share/OpenLieroX.*
	make_desktop_entry openlierox OpenLieroX OpenLieroX \
			"Game;ActionGame;ArcadeGame;"

	dobin "${CMAKE_BUILD_DIR}"/bin/openlierox
}
