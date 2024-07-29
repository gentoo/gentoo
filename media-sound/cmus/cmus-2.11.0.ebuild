# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/cmus/cmus.git"
	inherit git-r3
else
	SRC_URI="https://github.com/cmus/cmus/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Ncurses based music player with plugin support for many formats"
HOMEPAGE="https://cmus.github.io/"

S="${WORKDIR}/${P/_/-}"

LICENSE="GPL-2"
SLOT="0"
IUSE="aac alsa ao cddb cdio debug discid elogind examples ffmpeg +flac jack libsamplerate
	+mad mikmod modplug mp4 musepack opus oss pidgin pulseaudio sndio systemd tremor +unicode
	+vorbis wavpack"

# Both CONFIG_TREMOR=y and CONFIG_VORBIS=y are required to link to tremor libs instead of vorbis libs
REQUIRED_USE="
	?? ( elogind systemd )
	tremor? ( vorbis )
	mp4? ( aac )" # enabling mp4 adds -lfaad

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	sys-libs/ncurses:=[unicode(+)?]
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	ao? ( media-libs/libao )
	cddb? ( media-libs/libcddb )
	cdio? ( dev-libs/libcdio-paranoia )
	discid? ( media-libs/libdiscid )
	elogind? ( sys-auth/elogind )
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac:= )
	jack? ( virtual/jack )
	libsamplerate? ( media-libs/libsamplerate )
	mad? ( media-libs/libmad )
	mikmod? ( media-libs/libmikmod:0 )
	modplug? ( media-libs/libmodplug )
	mp4? ( media-libs/libmp4v2:0 )
	musepack? ( media-sound/musepack-tools )
	opus? ( media-libs/opusfile )
	pulseaudio? ( media-libs/libpulse )
	sndio? ( media-sound/sndio )
	systemd? ( sys-apps/systemd )
	tremor? ( media-libs/tremor )
	!tremor? ( vorbis? ( media-libs/libvorbis ) )
	wavpack? ( media-sound/wavpack )
"
RDEPEND="${DEPEND}
	pidgin? (
		dev-python/dbus-python
		net-im/pidgin
	)
"

DOCS=( AUTHORS README.md )

PATCHES=(
	"${FILESDIR}/${PN}-2.9.1-atomic.patch"
)

src_configure() {
	my_config() {
		local value
		use ${1} && value=a || value=n
		myconf+=( ${2}=${value} )
	}

	local debuglevel=1
	use debug && debuglevel=2
	local myconf=(
		CONFIG_CUE=y
		CONFIG_ARTS=n
		CONFIG_SUN=n
		CONFIG_SNDIO=n
		CONFIG_WAVEOUT=n
		CONFIG_VTX=n
		CONFIG_ROAR=n
	)

	my_config cddb CONFIG_CDDB
	my_config cdio CONFIG_CDIO
	my_config discid CONFIG_DISCID
	my_config flac CONFIG_FLAC
	my_config mad CONFIG_MAD
	my_config modplug CONFIG_MODPLUG
	my_config mikmod CONFIG_MIKMOD
	my_config musepack CONFIG_MPC
	my_config vorbis CONFIG_VORBIS
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
		myconf+=( CONFIG_MPRIS=a )
	else
		myconf+=( CONFIG_MPRIS=n )
	fi

	./configure prefix="${EPREFIX}"/usr "${myconf[@]}" \
		exampledir="${EPREFIX}"/usr/share/doc/${PF}/examples \
		libdir="${EPREFIX}"/usr/$(get_libdir) DEBUG=${debuglevel} || die
}

src_compile() {
	tc-export_build_env BUILD_CC
	emake V=2 \
		CC="$(tc-getCC)" LD="$(tc-getCC)" \
		HOSTCC="${BUILD_CC}" HOSTLD="${BUILD_CC}" \
		HOST_CFLAGS="${BUILD_CFLAGS}" HOST_LDFLAGS="${BUILD_LDFLAGS}"
}

src_install() {
	default

	if ! use examples; then
		rm -rf "${ED}"/usr/share/doc/${PF}/examples || die
	fi

	insinto /usr/share/zsh/site-functions
	doins contrib/_cmus

	newbashcomp contrib/${PN}.bash-completion ${PN}

	if use pidgin; then
		newbin contrib/cmus-updatepidgin.py cmus-updatepidgin
	fi
}
