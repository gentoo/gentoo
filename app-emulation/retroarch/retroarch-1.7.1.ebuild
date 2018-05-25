# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="A sophisticated libretro frontend for emulators, game engines and media players"
HOMEPAGE="https://retroarch.com/"
SRC_URI="https://github.com/libretro/RetroArch/archive/v${PV}.tar.gz -> ${P}.tar.gz"

IUSE="alsa cg +opengl +pulseaudio sdl X"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
LICENSE="GPL-3"
SLOT="0"

DEPEND="
	dev-libs/libxml2
	>=media-libs/freetype-2.8
	alsa? ( media-sound/alsa-utils )
	opengl? ( virtual/opengl )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( media-libs/libsdl2 )
	X? ( x11-libs/libX11 x11-apps/xinput )"

RDEPEND="
	${DEPEND}
	cg? ( media-gfx/nvidia-cg-toolkit )"

S="${WORKDIR}/RetroArch-${PV}"

src_prepare() {
	append-cflags "-v"
	default
}

src_configure() {
	./configure || die
}
