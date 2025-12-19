# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_PN="sox_ng"
MY_PV="${PV/_rc/-rc}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="The swiss army knife of sound processing programs"
HOMEPAGE="https://codeberg.org/sox_ng/sox_ng"
SRC_URI="https://codeberg.org/sox_ng/sox_ng/releases/download/${MY_P}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

# https://codeberg.org/sox_ng/sox_ng/wiki/Copyright
LICENSE="GPL-2"
SLOT="0/3" # SHLIB_VERSION in configure.ac
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="alsa amr ao encode +ffmpeg fftw flac id3tag ladspa mad ogg openmp oss opus png pulseaudio sndfile sndio speexdsp twolame wavpack"

RDEPEND="
	dev-libs/libltdl:0=
	>=media-sound/gsm-1.0.12-r1
	sys-apps/file
	alsa? ( media-libs/alsa-lib )
	amr? ( media-libs/opencore-amr )
	ao? ( media-libs/libao:= )
	encode? ( >=media-sound/lame-3.98.4 )
	ffmpeg? ( media-video/ffmpeg )
	fftw? ( sci-libs/fftw:3.0= )
	flac? ( >=media-libs/flac-1.1.3:= )
	id3tag? ( media-libs/libid3tag:= )
	ladspa? ( media-libs/ladspa-sdk )
	mad? ( media-libs/libmad )
	ogg? (
		media-libs/libogg
		media-libs/libvorbis
	)
	opus? (
		media-libs/opus
		media-libs/opusfile
	)
	png? (
		media-libs/libpng:0=
		virtual/zlib:=
	)
	pulseaudio? ( media-libs/libpulse )
	sndfile? ( >=media-libs/libsndfile-1.0.11 )
	sndio? ( media-sound/sndio:= )
	speexdsp? (
		media-libs/speex
		media-libs/speexdsp
	)
	twolame? ( media-sound/twolame )
	wavpack? ( media-sound/wavpack )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog  )

PATCHES=(
	"${FILESDIR}"/sox-14.6.0.2-fix-symlinks.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Workaround for LLD (bug #914867)
	# https://codeberg.org/sox_ng/sox_ng/issues/69
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)
	local myeconfargs=(
		$(use_with alsa)
		$(use_with amr amrnb)
		$(use_with amr amrwb)
		$(use_with ao)
		$(use_with encode lame)
		$(use_with ffmpeg)
		$(use_with fftw)
		$(use_with flac)
		$(use_with id3tag)
		$(use_with ladspa ladspa dyn)
		$(use_with mad)
		--with-magic
		$(use_enable openmp)
		$(use_with ogg oggvorbis)
		$(use_with oss)
		$(use_with opus)
		$(use_with png)
		$(use_with pulseaudio)
		$(use_with sndfile)
		$(use_with sndio)
		$(use_with speexdsp)
		$(use_with twolame)
		$(use_with wavpack)

		--with-dyn-default
		--enable-replace # bug #960558
		--disable-debug # user cflags
		--with-distro="Gentoo"

	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" \( -type f -or -type l \) -name '*.la' -delete || die
}
