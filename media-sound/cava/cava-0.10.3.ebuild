# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Console-based Audio Visualizer for Alsa"
HOMEPAGE="https://github.com/karlstav/cava/"
SRC_URI="
	https://github.com/karlstav/cava/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT Unlicense"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="alsa jack +ncurses pipewire portaudio pulseaudio sdl sndio"

RDEPEND="
	dev-libs/iniparser:4
	sci-libs/fftw:3.0=
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )
	ncurses? ( sys-libs/ncurses:= )
	pipewire? ( media-video/pipewire:= )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-libs/libpulse )
	sdl? (
		media-libs/libglvnd
		media-libs/libsdl2[opengl,video]
	)
	sndio? ( media-sound/sndio:= )
"
DEPEND="${RDEPEND}"
# bug #941845 wrt autoconf-archive bounds
BDEPEND="
	virtual/pkgconfig
	sdl? (
		|| (
			>dev-build/autoconf-archive-2024.10.16
			<dev-build/autoconf-archive-2024.10.16
		)
	)
"

src_prepare() {
	# TODO: depend on >=4.2.2 and remove after 4.2.2 is stable unless bug
	# #933610 reintroduces slotting hacks (also drop ${inip} below)
	local inip=
	if has_version '<dev-libs/iniparser-4.2.2:4'; then
		inip=4
		eapply "${FILESDIR}"/${PN}-0.10.3-gentoo-iniparser4.patch
	fi

	default

	# TODO: drop this when autoconf-archive is fixed (bug #941845), this is
	# to handle the USE=-sdl case given it breaks it present
	use sdl || sed -i 's/AX_CHECK_GL/&_DISABLED/' configure.ac || die

	# respect both ESYSROOT+slotting (can't use CPPFLAGS, comes before)
	sed -i "s|/usr/include/iniparser|${ESYSROOT}&${inip} |" configure.ac || die

	echo ${PV} > version || die
	eautoreconf
}

src_configure() {
	local econfargs=(
		$(use_enable alsa input-alsa)
		$(use_enable jack input-jack)
		$(use_enable pipewire input-pipewire)
		$(use_enable portaudio input-portaudio)
		$(use_enable pulseaudio input-pulse)
		$(use_enable sndio input-sndio)

		$(use_enable ncurses output-ncurses)
		$(use_enable sdl output-sdl)
		# note: not behind USE=opengl and sdl2[opengl?] given have not gotten
		# normal output-sdl to work without USE=opengl on sdl either way
		$(use_enable sdl output-sdl_glsl)
	)

	# autoconf-archive (currently) does not support -lOpenGL for libglvnd[-X]
	use sdl && econfargs+=( GL_LIBS="$($(tc-getPKG_CONFIG) --libs opengl || die)" )

	econf "${econfargs[@]}"
}

pkg_postinst() {
	if [[ ! ${REPLACING_VERSIONS##* } ]]; then
		elog "A default ~/.config/cava/config will be created after initial"
		elog "use of ${PN}, see it and ${EROOT}/usr/share/doc/${PF}/README*"
		elog "for configuring audio input and more."
	fi
}
