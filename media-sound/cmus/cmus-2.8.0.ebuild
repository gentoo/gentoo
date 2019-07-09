# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/cmus/cmus.git"
	inherit git-r3
else
	SRC_URI="https://github.com/cmus/cmus/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ppc ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
fi

DESCRIPTION="Ncurses based music player with plugin support for many formats"
HOMEPAGE="https://cmus.github.io/"

LICENSE="GPL-2"
SLOT="0"
IUSE="aac alsa ao cddb cdio cue debug discid elogind examples ffmpeg +flac jack libsamplerate
	+mad mikmod modplug mp4 musepack opus oss pidgin pulseaudio systemd tremor +unicode
	+vorbis wavpack"

REQUIRED_USE="?? ( elogind systemd )"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	sys-libs/ncurses:0=[unicode?]
	aac? ( media-libs/faad2 )
	alsa? ( >=media-libs/alsa-lib-1.0.11 )
	ao? ( media-libs/libao )
	cddb? ( media-libs/libcddb )
	cdio? ( dev-libs/libcdio-paranoia )
	cue? ( media-libs/libcue )
	discid? ( media-libs/libdiscid )
	elogind? ( sys-auth/elogind )
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac )
	jack? ( virtual/jack )
	libsamplerate? ( media-libs/libsamplerate )
	mad? ( >=media-libs/libmad-0.14 )
	mikmod? ( media-libs/libmikmod:0 )
	modplug? ( >=media-libs/libmodplug-0.7 )
	mp4? ( >=media-libs/libmp4v2-1.9:0 )
	musepack? ( >=media-sound/musepack-tools-444 )
	opus? ( media-libs/opusfile )
	pulseaudio? ( media-sound/pulseaudio )
	systemd? ( sys-apps/systemd )
	tremor? ( media-libs/tremor )
	!tremor? ( vorbis? ( >=media-libs/libvorbis-1.0 ) )
	wavpack? ( media-sound/wavpack )
"
RDEPEND="${DEPEND}
	pidgin? (
		dev-python/dbus-python
		net-im/pidgin
	)
"

# Both CONFIG_TREMOR=y and CONFIG_VORBIS=y are required to link to tremor libs instead of vorbis libs
REQUIRED_USE="tremor? ( vorbis )
	mp4? ( aac )" # enabling mp4 adds -lfaad

DOCS=( AUTHORS README.md )

PATCHES=(
	"${FILESDIR}/${P}-elogind.patch"
	"${FILESDIR}/${P}-ffmpeg-deprecations.patch"
	"${FILESDIR}/${P}-opus.patch"
)

S="${WORKDIR}/${P/_/-}"

my_config() {
	local value
	use ${1} && value=a || value=n
	myconf="${myconf} ${2}=${value}"
}

src_configure() {
	local debuglevel=1 myconf="CONFIG_ARTS=n CONFIG_SUN=n CONFIG_SNDIO=n CONFIG_WAVEOUT=n CONFIG_VTX=n CONFIG_ROAR=n"

	use debug && debuglevel=2

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
	my_config cue CONFIG_CUE
	my_config pulseaudio CONFIG_PULSE
	my_config alsa CONFIG_ALSA
	my_config jack CONFIG_JACK
	my_config libsamplerate CONFIG_SAMPLERATE
	my_config ao CONFIG_AO
	my_config oss CONFIG_OSS

	if use elogind || use systemd; then
		myconf="${myconf} CONFIG_MPRIS=a"
	else
		myconf="${myconf} CONFIG_MPRIS=n"
	fi

	./configure prefix="${EPREFIX}"/usr ${myconf} \
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
