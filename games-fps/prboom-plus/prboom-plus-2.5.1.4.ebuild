# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop xdg

DESCRIPTION="A Doom source port developed from the original PrBoom project"
HOMEPAGE="https://prboom-plus.sourceforge.net"
# We are using a github mirror here because the upstream tarball is missing the
# free dog assets; we should update SRC_URI to point to the upstream tarball
# once the free assets are present as expected
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/coelckers/prboom-plus/archive/f96f891d068dcc5ec52ed91056b46d27e9a8462d.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+
	nonfree? ( freedist )
	!nonfree? ( BSD )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dumb fluidsynth mad net nonfree +opengl pcre +png portmidi sdl-image +sdl-mixer vorbis"
REQUIRED_USE="sdl-image? ( opengl )"

DEPEND="
	media-libs/libsdl[opengl?,joystick,sound,video]
	dumb? ( media-libs/dumb )
	fluidsynth? ( media-sound/fluidsynth:= )
	mad? ( media-libs/libmad )
	net? ( media-libs/sdl-net )
	sdl-image? ( media-libs/sdl-image )
	pcre? ( dev-libs/libpcre:3 )
	png? ( media-libs/libpng:0= )
	portmidi? ( media-libs/portmidi )
	sdl-mixer? ( media-libs/sdl-mixer[midi] )
	vorbis? ( media-libs/libvorbis )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/prboom-plus-f96f891d068dcc5ec52ed91056b46d27e9a8462d/prboom2"
PATCHES="${FILESDIR}/${P}-Remove-nonstandard-gamesdir-variable.patch"

src_prepare() {
	xdg_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		--disable-cpu-opt \
		$(use_enable nonfree nonfree-graphics) \
		$(use_enable opengl gl) \
		$(use_with dumb) \
		$(use_with fluidsynth) \
		$(use_with mad) \
		$(use_with net) \
		$(use_with pcre) \
		$(use_with png) \
		$(use_with portmidi) \
		$(use_with sdl-image image) \
		$(use_with sdl-mixer mixer) \
		$(use_with vorbis vorbisfile) \
		--with-waddir="${EPREFIX}/usr/share/doom"
}

src_install() {
	default
	newicon ICONS/prboom-plus.svg ${PN}.svg
	make_desktop_entry "${PN}" "PrBoom+"
}
