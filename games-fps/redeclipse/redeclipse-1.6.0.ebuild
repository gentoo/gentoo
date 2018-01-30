# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop

DESCRIPTION="First-person ego-shooter, built as a total conversion of Cube Engine 2"
HOMEPAGE="http://www.redeclipse.net/"
SRC_URI="https://github.com/red-eclipse/base/releases/download/v${PV}/${PN}_${PV}_nix.tar.bz2"

# According to doc/license.txt file
LICENSE="HPND ZLIB CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated"

DEPEND="!dedicated? (
		media-libs/freetype:2
		media-libs/libsdl:0[opengl]
		media-libs/sdl2-image:0[jpeg,png]
		media-libs/sdl2-mixer:0[mp3,vorbis]
		virtual/opengl
		x11-libs/libX11
	)
	>=net-libs/enet-1.3.9
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e "s:@APPNAME@:${PN}:" \
		src/install/nix/redeclipse.desktop.am \
		> src/install/nix/redeclipse.desktop || die

	if ! use dedicated; then
		sed -e "s:@LIBEXECDIR@:/usr/libexec:g" \
			-e "s:@DATADIR@:/usr/share:g" \
			-e "s:@DOCDIR@:/usr/share/doc/${PF}:" \
			-e "s:@CAPPNAME@:${PN^^}:g" \
			-e "s:@APPNAME@:${PN}:g" \
			doc/man/redeclipse.6.am \
			> doc/man/redeclipse.6 || die
	fi

	sed -e "s:@LIBEXECDIR@:/usr/libexec:g" \
		-e "s:@DATADIR@:/usr/share:g" \
		-e "s:@DOCDIR@:/usr/share/doc/${PF}:" \
		-e "s:@CAPPNAME@:${PN^^}:g" \
		-e "s:@APPNAME@:${PN}:g" \
		doc/man/redeclipse-server.6.am \
		> doc/man/redeclipse-server.6 || die

	default
}

src_compile() {
	if ! use dedicated; then
		emake CXXFLAGS="${CXXFLAGS}" STRIP= -C src client server
	else
		emake CXXFLAGS="${CXXFLAGS}" STRIP= -C src server
	fi
}

src_install() {
	insinto /usr/share/redeclipse
	doins -r config data

	dobin src/redeclipse_server_linux

	if ! use dedicated; then
		dobin src/redeclipse_linux
		newicon "src/install/nix/${PN}_x128.png" "${PN}.png"
		make_desktop_entry "src/install/nix/${PN}.desktop"
		doman doc/man/redeclipse.6
	fi

	doman doc/man/redeclipse-server.6
	dodoc readme.txt doc/examples/servinit.cfg
}
