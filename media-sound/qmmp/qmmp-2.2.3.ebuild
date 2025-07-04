# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Qt-based audio player with winamp/xmms skins support"
HOMEPAGE="https://qmmp.ylsoftware.com"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="
		https://qmmp.ylsoftware.com/files/qmmp/$(ver_cut 1-2)/${P}.tar.bz2
		https://downloads.sourceforge.net/project/qmmp-dev/qmmp/$(ver_cut 1-2)/${P}.tar.bz2
	"
	KEYWORDS="amd64 x86"
else
	inherit subversion
	QMMP_DEV_BRANCH="2.2"
	ESVN_REPO_URI="svn://svn.code.sf.net/p/${PN}-dev/code/branches/${PN}-${QMMP_DEV_BRANCH}"
fi

LICENSE="CC-BY-SA-4.0 GPL-2+" # default skin & source code
SLOT="0"
# KEYWORDS further up
# NOTE: drop mms in >2.2.3
# https://sourceforge.net/p/qmmp-dev/code/12062/
IUSE="X aac +alsa archive bs2b cdda cddb curl +dbus doc enca
ffmpeg flac game gnome jack ladspa libxmp +mad midi mms mpg123
mplayer musepack opus pipewire projectm pulseaudio qtmedia
shout sid sndfile soxr udisks +vorbis wavpack
"
REQUIRED_USE="
	cddb? ( cdda )
	gnome? ( dbus )
	jack? ( soxr )
	shout? ( soxr vorbis )
	udisks? ( dbus )
"
# qtbase[sql] to help autounmask of sqlite
RDEPEND="
	dev-qt/qtbase:6[X?,dbus?,gui,network,sql,sqlite,widgets]
	media-libs/taglib:=
	X? (
		x11-libs/libX11
		x11-libs/libxcb:=
	)
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	archive? ( app-arch/libarchive )
	bs2b? ( media-libs/libbs2b )
	cdda? (
		dev-libs/libcdio:=
		dev-libs/libcdio-paranoia:=
	)
	cddb? ( media-libs/libcddb )
	curl? ( net-misc/curl )
	enca? ( app-i18n/enca )
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac:= )
	game? ( media-libs/game-music-emu )
	jack? (	virtual/jack )
	ladspa? ( media-plugins/cmt-plugins )
	libxmp? ( media-libs/libxmp )
	mad? ( media-libs/libmad )
	midi? ( media-sound/wildmidi )
	mms? ( media-libs/libmms )
	mpg123? ( media-sound/mpg123 )
	mplayer? ( media-video/mplayer )
	musepack? ( >=media-sound/musepack-tools-444 )
	opus? ( media-libs/opusfile )
	pipewire? ( media-video/pipewire:= )
	projectm? (
		dev-qt/qtbase:6[-gles2-only,opengl]
		media-libs/libglvnd
		media-libs/libprojectm:=
	)
	pulseaudio? ( media-libs/libpulse )
	qtmedia? ( dev-qt/qtmultimedia:6 )
	shout? ( media-libs/libshout )
	sid? ( >=media-libs/libsidplayfp-1.1.0:= )
	sndfile? ( media-libs/libsndfile )
	soxr? ( media-libs/soxr )
	udisks? ( sys-fs/udisks:2 )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	wavpack? ( media-sound/wavpack )
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	doc? ( app-text/doxygen )
"

DOCS=( AUTHORS ChangeLog README )

PATCHES=( "${FILESDIR}"/${P}_build-with-projectm4.patch )

src_configure() {
	local mycmakeargs=(
		# our defaults
		-DUSE_CONVERTER=ON # because taglib
		-DUSE_RGSCAN=ON # because taglib
		-DUSE_LIBRARY=ON # because qtbase[sqlite]

		# depless non-default options
		-DUSE_OSS=ON

		# turn off windows specific stuff
		-DUSE_DSOUND=OFF
		-DUSE_TASKBAR=OFF
		-DUSE_RDETECT=OFF
		-DUSE_WASAPI=OFF
		-DUSE_WAVEOUT=OFF
		# set USE flags
		-DUSE_AAC="$(usex aac)"
		-DUSE_ALSA="$(usex alsa)"
		-DUSE_ARCHIVE="$(usex archive)"
		-DUSE_BS2B="$(usex bs2b)"
		-DUSE_CDA="$(usex cdda)"
		-DUSE_LIBCDDB="$(usex cddb)"
		-DUSE_CURL="$(usex curl)"
		-DUSE_KDENOTIFY="$(usex dbus)"
		-DUSE_MPRIS="$(usex dbus)"
		-DUSE_ENCA="$(usex enca)"
		-DUSE_FFMPEG="$(usex ffmpeg)"
		-DUSE_FILEWRITER="$(usex vorbis)"
		-DUSE_FLAC="$(usex flac)"
		-DUSE_GME="$(usex game)"
		-DUSE_GNOMEHOTKEY="$(usex gnome)"
		-DUSE_HOTKEY="$(usex X)"
		-DUSE_JACK="$(usex jack)"
		-DUSE_LADSPA="$(usex ladspa)"
		-DUSE_MAD="$(usex mad)"
		-DUSE_MIDI="$(usex midi)"
		-DUSE_MMS="$(usex mms)"
		-DUSE_MPG123="$(usex mpg123)"
		-DUSE_MPLAYER="$(usex mplayer)"
		-DUSE_MPC="$(usex musepack)"
		-DUSE_NOTIFIER="$(usex X)"
		-DUSE_OPUS="$(usex opus)"
		-DUSE_PIPEWIRE="$(usex pipewire)"
		-DUSE_PROJECTM="$(usex projectm)"
		-DUSE_PULSE="$(usex pulseaudio)"
		-DUSE_QTMULTIMEDIA="$(usex qtmedia)"
		-DUSE_SHOUT="$(usex shout)"
		-DUSE_SID="$(usex sid)"
		-DUSE_SKINNED="$(usex X)"
		-DUSE_SNDFILE="$(usex sndfile)"
		-DUSE_SOXR="$(usex soxr)"
		-DUSE_UDISKS="$(usex udisks)"
		-DUSE_VORBIS="$(usex vorbis)"
		-DUSE_WAVPACK="$(usex wavpack)"
		-DUSE_XMP="$(usex libxmp)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && {
		cmake_build docs
		HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
	}
}
