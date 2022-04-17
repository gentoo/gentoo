# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Console-based Audio Visualizer"
HOMEPAGE="https://github.com/karlstav/cava/"
SRC_URI="https://github.com/karlstav/cava/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa +ncurses portaudio pulseaudio sdl sndio"

RDEPEND="
	dev-libs/iniparser:4
	sci-libs/fftw:=
	alsa? ( media-libs/alsa-lib )
	ncurses? ( sys-libs/ncurses:= )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( media-libs/libsdl2[opengl,video] )
	sndio? ( media-sound/sndio:= )"
DEPEND="${RDEPEND}"
BDEPEND="app-editors/vim-core"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.0-gentoo-iniparser4.patch
	"${FILESDIR}"/${P}-maxed-bars.patch
)

src_prepare() {
	default

	# see autogen.sh
	echo ${PV} > version || die
	xxd -i example_files/config config_file.h || die

	sed -i 's/-Werror //' Makefile.am || die

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
		elog "for configuring audio inputs and more."
	fi

	if use !alsa && use !portaudio && use !pulseaudio && use !sndio; then
		# give a warning given greets with a segfault without proper configuration
		ewarn "All audio backends are disabled, ${PN} will only function if first"
		ewarn "configured to use 'method = fifo' or 'shmem'."
		ewarn "Tip: fifo is versatile, e.g. mkfifo fifo && jack_capture --daemon -ws > fifo"
	fi
}
