# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="A collection of command line audio tools"
HOMEPAGE="http://audiotools.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aac alsa cdda cdr cue dvda flac gui twolame mp3 opus pulseaudio vorbis wavpack"

BDEPEND="virtual/pkgconfig"
DEPEND="
	alsa? ( media-libs/alsa-lib )
	cdda? ( dev-libs/libcdio-paranoia:0= )
	dvda? ( media-libs/libdvd-audio )
	twolame? ( media-sound/twolame )
	mp3? ( || ( media-sound/mpg123 media-sound/lame ) )
	opus? (
		media-libs/opus
		media-libs/opusfile
	)
	pulseaudio? ( media-sound/pulseaudio )
	vorbis? ( media-libs/libvorbis )
	wavpack? ( media-sound/wavpack )
"
RDEPEND="${DEPEND}
	aac? (
		media-libs/faad2
		media-libs/faac
	)
	cdr? ( virtual/cdrtools )
	cue? ( app-cdr/cdrdao )
	flac? ( media-libs/flac )
	gui? (
		$(python_gen_impl_dep 'tk(+)')
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/urwid[${PYTHON_USEDEP}]
	)
"

# lots of random failures
RESTRICT="test"

PATCHES=( "${FILESDIR}"/${P}-libcdio-paranoia.patch )

src_prepare() {
	default

	local USEFLAG_LIBS=(
		cdda:libcdio_paranoia
		dvda:libdvd-audio
		pulseaudio:libpulse
		alsa:alsa
		mp3:libmpg123
		mp3:mp3lame
		vorbis:vorbisfile
		vorbis:vorbisenc
		opus:opusfile
		opus:opus
		twolame:twolame
	)

	# enable/disable deps based on USE flags
	local flag_lib flag lib
	for flag_lib in "${USEFLAG_LIBS[@]}"; do
		flag=${flag_lib/:*}
		lib=${flag_lib/*:}
		use ${flag} || { sed -i "/^${lib}:/s/probe/no/" setup.cfg || die; }
	done
}

python_compile_all() {
	emake -C docs
}

python_test() {
	cd test || die
	"${PYTHON}" test.py || die
}

python_install_all() {
	doman docs/*.{1,5}
	distutils-r1_python_install_all
}
