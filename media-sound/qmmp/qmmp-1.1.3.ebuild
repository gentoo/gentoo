# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils
[ "$PV" == "9999" ] && inherit subversion

DESCRIPTION="Qt5-based audio player with winamp/xmms skins support"
HOMEPAGE="http://qmmp.ylsoftware.com"
if [ "$PV" != "9999" ]; then
	SRC_URI="http://qmmp.ylsoftware.com/files/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	QMMP_DEV_BRANCH="1.1"
	SRC_URI=""
	ESVN_REPO_URI="svn://svn.code.sf.net/p/${PN}-dev/code/branches/${PN}-${QMMP_DEV_BRANCH}"
	KEYWORDS=""
fi

LICENSE="GPL-2"
SLOT="0"
# KEYWORDS further up
IUSE="analyzer aac +alsa bs2b cdda cover crossfade cue curl enca ffmpeg flac jack game kde ladspa
lyrics +mad midi mms modplug mplayer mpris musepack notifier opus oss projectm
pulseaudio qsui scrobbler sndfile soxr stereo tray udisks +vorbis wavpack"

RDEPEND="media-libs/taglib
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	alsa? ( media-libs/alsa-lib )
	bs2b? ( media-libs/libbs2b )
	cdda? ( dev-libs/libcdio-paranoia )
	cue? ( media-libs/libcue )
	curl? ( net-misc/curl )
	aac? ( media-libs/faad2 )
	enca? ( app-i18n/enca )
	flac? ( media-libs/flac )
	game? ( media-libs/game-music-emu )
	ladspa? ( media-libs/ladspa-cmt )
	mad? ( media-libs/libmad )
	midi? ( media-sound/wildmidi )
	mms? ( media-libs/libmms )
	mplayer? ( media-video/mplayer )
	mpris? ( dev-qt/qtdbus:5 )
	musepack? ( >=media-sound/musepack-tools-444 )
	modplug? ( >=media-libs/libmodplug-0.8.4 )
	vorbis? ( media-libs/libvorbis
		media-libs/libogg )
	jack? ( media-sound/jack-audio-connection-kit
		media-libs/libsamplerate )
	ffmpeg? ( virtual/ffmpeg )
	opus? ( media-libs/opusfile )
	projectm? ( media-libs/libprojectm
		dev-qt/qtopengl:5
		dev-qt/qtgui:5[-gles2] )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.9 )
	wavpack? ( media-sound/wavpack )
	scrobbler? ( net-misc/curl )
	sndfile? ( media-libs/libsndfile )
	soxr? ( media-libs/soxr )
	udisks? ( sys-fs/udisks:2 )"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5"

DOCS="AUTHORS ChangeLog README"

CMAKE_IN_SOURCE_BUILD="1"

src_prepare() {
	if has_version dev-libs/libcdio-paranoia; then
		sed -i \
			-e 's:cdio/cdda.h:cdio/paranoia/cdda.h:' \
			src/plugins/Input/cdaudio/decoder_cdaudio.cpp || die
	fi

	cmake-utils_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DUSE_ALSA="$(usex alsa)"
		-DUSE_AAC="$(usex aac)"
		-DUSE_ANALYZER="$(usex analyzer)"
		-DUSE_BS2B="$(usex bs2b)"
		-DUSE_CDA="$(usex cdda)"
		-DUSE_CROSSFADE="$(usex crossfade)"
		-DUSE_COVER="$(usex cover)"
		-DUSE_CUE="$(usex cue)"
		-DUSE_CURL="$(usex curl)"
		-DUSE_ENCA="$(usex enca)"
		-DUSE_FFMPEG="$(usex ffmpeg)"
		-DUSE_FLAC="$(usex flac)"
		-DUSE_GME="$(usex game)"
		-DUSE_HAL=OFF
		-DUSE_JACK="$(usex jack)"
		-DUSE_KDENOTIFY="$(usex kde)"
		-DUSE_LADSPA="$(usex ladspa)"
		-DUSE_LYRICS="$(usex lyrics)"
		-DUSE_MAD="$(usex mad)"
		-DUSE_MIDI="$(usex midi)"
		-DUSE_MPLAYER="$(usex mplayer)"
		-DUSE_MMS="$(usex mms)"
		-DUSE_MODPLUG="$(usex modplug)"
		-DUSE_MPRIS="$(usex mpris)"
		-DUSE_MPC="$(usex musepack)"
		-DUSE_NOTIFIER="$(usex notifier)"
		-DUSE_OPUS="$(usex opus)"
		-DUSE_OSS="$(usex oss)"
		-DUSE_PROJECTM="$(usex projectm)"
		-DUSE_PULSE="$(usex pulseaudio)"
		-DUSE_QSUI="$(usex qsui)"
		-DUSE_SCROBBLER="$(usex scrobbler)"
		-DUSE_SNDFILE="$(usex sndfile)"
		-DUSE_SOXR="$(usex soxr)"
		-DUSE_STEREO="$(usex stereo)"
		-DUSE_STATICON="$(usex tray)"
		-DUSE_UDISKS2="$(usex udisks)"
		-DUSE_VORBIS="$(usex vorbis)"
		-DUSE_WAVPACK="$(usex wavpack)"
	)

	cmake-utils_src_configure
}
