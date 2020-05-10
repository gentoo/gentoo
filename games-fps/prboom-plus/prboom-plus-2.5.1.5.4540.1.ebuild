# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop xdg

MY_PV=$(ver_rs 4 "+svn" 5 "+dfsg")
MY_P=${PN}-${MY_PV}
DESCRIPTION="An enhanced clone of the classic first-person shooter Doom"
HOMEPAGE="http://prboom-plus.sourceforge.net"
SRC_URI="http://deb.debian.org/debian/pool/main/p/prboom-plus/${PN}_${MY_PV}.orig.tar.xz -> ${P}.tar.xz"

LICENSE="GPL-2+ BSD BSD-with-disclosure LGPL-2.1+ MIT public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dumb fluidsynth mad net +opengl +pcre portmidi sdl2-image +sdl2-mixer vorbis"
REQUIRED_USE="sdl2-image? ( opengl )"

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
	vorbis? ( media-libs/libvorbis )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}
PATCHES=(
	"${FILESDIR}/${PN}-2.5.1.4-Remove-nonstandard-gamesdir-variable.patch"
)

src_prepare() {
	xdg_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		--disable-cpu-opt \
		--disable-nonfree-graphics \
		$(use_enable opengl gl) \
		$(use_with dumb) \
		$(use_with fluidsynth) \
		$(use_with mad) \
		$(use_with net) \
		$(use_with pcre) \
		$(use_with portmidi) \
		$(use_with sdl2-image image) \
		$(use_with sdl2-mixer mixer) \
		$(use_with vorbis vorbisfile) \
		--with-waddir="${EPREFIX}/usr/share/doom"
}

src_install() {
	default
	doicon ICONS/${PN}.svg
	domenu ICONS/${PN}.desktop
}
