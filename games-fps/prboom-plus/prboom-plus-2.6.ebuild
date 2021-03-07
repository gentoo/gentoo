# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg

DESCRIPTION="An enhanced clone of the classic first-person shooter Doom"
HOMEPAGE="https://github.com/coelckers/prboom-plus/"
SRC_URI="http://deb.debian.org/debian/pool/main/p/prboom-plus/${PN}_${PV}um.orig.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ GPL-3+ BSD BSD-2 BSD-with-disclosure CC-BY-3.0 CC0-1.0 LGPL-2.1+ MIT public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dumb fluidsynth mad net +opengl +pcre portmidi sdl2-image +sdl2-mixer server vorbis zlib"
REQUIRED_USE="server? ( net )"

DEPEND="
	media-libs/libsdl2[opengl?,joystick,sound,video]
	dumb? ( media-libs/dumb:= )
	fluidsynth? ( media-sound/fluidsynth:= )
	mad? ( media-libs/libmad )
	net? ( media-libs/sdl2-net )
	pcre? ( dev-libs/libpcre:3 )
	portmidi? ( media-libs/portmidi )
	sdl2-image? ( media-libs/sdl2-image )
	sdl2-mixer? ( media-libs/sdl2-mixer[midi] )
	vorbis? ( media-libs/libvorbis )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}um/prboom2"

src_prepare() {
	eapply -p2 "${FILESDIR}/${P}-Set-CMAKE_INSTALL_DOCDIR-as-a-cache-entry.patch"
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_GL="$(usex opengl)"
		-DWITH_IMAGE="$(usex sdl2-image)"
		-DWITH_MIXER="$(usex sdl2-mixer)"
		-DWITH_NET="$(usex net)"
		-DWITH_PCRE="$(usex pcre)"
		-DWITH_ZLIB="$(usex zlib)"
		-DWITH_MAD="$(usex mad)"
		-DWITH_FLUIDSYNTH="$(usex fluidsynth)"
		-DWITH_DUMB="$(usex dumb)"
		-DWITH_VORBISFILE="$(usex vorbis)"
		-DWITH_PORTMIDI="$(usex portmidi)"
		-DDOOMWADDIR="${EPREFIX}/usr/share/doom"
		-DWAD_DATA_PATH="${EPREFIX}/usr/share/doom"
		-DBUILD_SERVER="$(usex server)"
	)
	cmake_src_configure
}

src_install() {
	doicon -s scalable ICONS/${PN}.svg
	domenu ICONS/${PN}.desktop
	cmake_src_install
}
