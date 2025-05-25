# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg

DESCRIPTION="A successor to the PrBoom+ Doom source port"
HOMEPAGE="https://github.com/kraflab/dsda-doom/"
SRC_URI="https://github.com/kraflab/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${P}/prboom2"

LICENSE="GPL-2+ GPL-3+ BSD BSD-2 BSD-with-disclosure CC-BY-3.0 CC0-1.0 LGPL-2.1+ MIT public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="fluidsynth mad portmidi sdl2-image vorbis"

DEPEND="
	media-libs/libsdl2[opengl,joystick,sound,video]
	media-libs/sdl2-mixer[midi]
	fluidsynth? ( media-sound/fluidsynth:= )
	mad? ( media-libs/libmad )
	portmidi? ( media-libs/portmidi )
	sdl2-image? ( media-libs/sdl2-image )
	media-libs/sdl2-mixer[midi]
	vorbis? ( media-libs/libvorbis )
	dev-libs/libzip:=
	sys-libs/zlib:=
	virtual/glu
	virtual/opengl
"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply -p2 "${FILESDIR}/${P}-versioned-doc.patch"
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_IMAGE="$(usex sdl2-image)"
		-DWITH_MAD="$(usex mad)"
		-DWITH_FLUIDSYNTH="$(usex fluidsynth)"
		-DWITH_DUMB="OFF"
		-DWITH_VORBISFILE="$(usex vorbis)"
		-DWITH_PORTMIDI="$(usex portmidi)"
		-DDOOMWADDIR="${EPREFIX}/usr/share/doom"
		-DDSDAPWADDIR="${EPREFIX}/usr/share/${PF}"
		-DWAD_DATA_PATH="${EPREFIX}/usr/share/doom"
	)
	cmake_src_configure
}

src_install() {
	doicon -s scalable ICONS/${PN}.svg
	domenu ICONS/${PN}.desktop
	cmake_src_install
}
