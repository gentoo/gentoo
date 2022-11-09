# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Console-based Audio Visualizer for Alsa"
HOMEPAGE="https://github.com/karlstav/cava/"
SRC_URI="https://github.com/karlstav/cava/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="alsa +ncurses portaudio pulseaudio sdl sndio"

RDEPEND="
	dev-libs/iniparser:4
	sci-libs/fftw:3.0=
	alsa? ( media-libs/alsa-lib )
	ncurses? ( sys-libs/ncurses:= )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-libs/libpulse )
	sdl? ( media-libs/libsdl2[opengl,video] )
	sndio? ( media-sound/sndio:= )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.0-gentoo-iniparser4.patch
)

src_prepare() {
	default

	# https://github.com/karlstav/cava/issues/450
	sed -i 's/-Werror //' Makefile.am || die

	echo ${PV} > version || die
	eautoreconf
}

src_configure() {
	local econfargs=(
		$(use_enable alsa input-alsa)
		$(use_enable portaudio input-portaudio)
		$(use_enable pulseaudio input-pulse)
		$(use_enable sndio input-sndio)

		$(use_enable ncurses output-ncurses)
		$(use_enable sdl output-sdl)

		GENTOO_SYSROOT="${ESYSROOT}" # see iniparser4.patch
	)

	econf "${econfargs[@]}"
}

pkg_postinst() {
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "A default ~/.config/cava/config will be created after initial"
		elog "use of ${PN}, see it and ${EROOT}/usr/share/doc/${PF}/README*"
		elog "for configuring audio input and more."
	fi
}
