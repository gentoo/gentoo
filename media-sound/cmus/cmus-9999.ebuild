# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit flag-o-matic python-single-r1 shell-completion toolchain-funcs

DESCRIPTION="Ncurses based music player with plugin support for many formats"
HOMEPAGE="https://cmus.github.io/ https://github.com/cmus/cmus"
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/cmus/cmus.git"
	inherit git-r3
else
	SRC_URI="https://github.com/cmus/cmus/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="aac alsa ao cddb cdio debug discid elogind ffmpeg +flac jack libsamplerate
	+mad mikmod modplug mp4 musepack opus oss pidgin pulseaudio sndio systemd
	tremor +unicode +vorbis wavpack"
REQUIRED_USE="
	?? ( elogind systemd )
	?? ( tremor vorbis )
	pidgin? ( ${PYTHON_REQUIRED_USE} )
"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	sys-libs/ncurses:=[unicode(+)?]
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	ao? ( media-libs/libao )
	cdio? (
		dev-libs/libcdio:=
		dev-libs/libcdio-paranoia:=
		cddb? ( media-libs/libcddb )
	)
	discid? ( media-libs/libdiscid )
	elogind? ( sys-auth/elogind )
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac:= )
	jack? (
		virtual/jack
		libsamplerate? ( media-libs/libsamplerate )
	)
	mad? ( media-libs/libmad )
	mikmod? ( media-libs/libmikmod:0 )
	modplug? ( media-libs/libmodplug )
	mp4? (
		media-libs/faad2
		media-libs/libmp4v2:0
	)
	musepack? ( media-sound/musepack-tools )
	opus? ( media-libs/opusfile )
	pulseaudio? ( media-libs/libpulse )
	sndio? ( media-sound/sndio:= )
	systemd? ( sys-apps/systemd )
	tremor? ( media-libs/tremor )
	vorbis? ( media-libs/libvorbis )
	wavpack? ( media-sound/wavpack )
"
RDEPEND="${DEPEND}
	pidgin? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/dbus-python[${PYTHON_USEDEP}]')
		net-im/pidgin
	)
"

pkg_setup() {
	use pidgin && python-single-r1_pkg_setup
}

src_configure() {
	append-atomic-flags #639678
	tc-export_build_env BUILD_CC
	tc-export CC PKG_CONFIG
	local myconf=(
		HOSTCC="${BUILD_CC}"
		HOSTLD="${BUILD_CC}"
		HOST_CFLAGS="${BUILD_CFLAGS}"
		HOST_LDFLAGS="${BUILD_LDFLAGS}"
		LD="${CC}"

		prefix="${EPREFIX}"/usr
		exampledir="${EPREFIX}"/usr/share/doc/${PF}/examples
		libdir="${EPREFIX}"/usr/$(get_libdir)
		DEBUG=$(usex debug 2 1)
	)

	myconf+=(
		CONFIG_CUE=y
		CONFIG_ARTS=n
		CONFIG_SUN=n
		CONFIG_WAVEOUT=n
		CONFIG_VTX=n
		CONFIG_ROAR=n
	)

	my_config() {
		local value
		use ${1} && value=y || value=n
		myconf+=( ${2}=${value} )
	}

	my_config cddb CONFIG_CDDB
	my_config cdio CONFIG_CDIO
	my_config discid CONFIG_DISCID
	my_config flac CONFIG_FLAC
	my_config mad CONFIG_MAD
	my_config modplug CONFIG_MODPLUG
	my_config mikmod CONFIG_MIKMOD
	my_config musepack CONFIG_MPC
	my_config tremor CONFIG_TREMOR
	my_config opus CONFIG_OPUS
	my_config wavpack CONFIG_WAVPACK
	my_config mp4 CONFIG_MP4
	my_config aac CONFIG_AAC
	my_config ffmpeg CONFIG_FFMPEG
	my_config pulseaudio CONFIG_PULSE
	my_config alsa CONFIG_ALSA
	my_config jack CONFIG_JACK
	my_config sndio CONFIG_SNDIO
	my_config libsamplerate CONFIG_SAMPLERATE
	my_config ao CONFIG_AO
	my_config oss CONFIG_OSS

	if use elogind || use systemd; then
		myconf+=( CONFIG_MPRIS=y )
	else
		myconf+=( CONFIG_MPRIS=n )
	fi

	# Both CONFIG_TREMOR=y and CONFIG_VORBIS=y for tremor
	if use vorbis || use tremor; then
		myconf+=( CONFIG_VORBIS=y )
	else
		myconf+=( CONFIG_VORBIS=n )
	fi

	./configure "${myconf[@]}" || die
}

src_compile() {
	emake V=2
}

src_install() {
	default

	dozshcomp contrib/_cmus
	newbashcomp contrib/${PN}.bash-completion ${PN}

	if use pidgin; then
		python_newscript contrib/cmus-updatepidgin.py cmus-updatepidgin
	fi
}
