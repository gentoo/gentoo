# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils
[ "$PV" == "9999" ] && inherit subversion

DESCRIPTION="Qt4-based audio player with winamp/xmms skins support"
HOMEPAGE="http://qmmp.ylsoftware.com"
if [ "$PV" != "9999" ]; then
	SRC_URI="http://qmmp.ylsoftware.com/files/${P}.tar.bz2"
	KEYWORDS="~amd64 ~ppc ~x86"
else
	SRC_URI=""
	ESVN_REPO_URI="https://qmmp.googlecode.com/svn/trunk/qmmp/"
	KEYWORDS=""
fi

LICENSE="GPL-2"
SLOT="0"
# KEYWORDS further up
IUSE="analyzer aac +alsa +dbus bs2b cdda cover crossfade cue curl enca ffmpeg flac jack game kde ladspa
libsamplerate lyrics +mad midi mms modplug mplayer mpris musepack notifier opus oss
projectm pulseaudio qsui scrobbler sndfile stereo tray udisks +vorbis wavpack"

RDEPEND="media-libs/taglib
	dev-qt/qtgui:4
	alsa? ( media-libs/alsa-lib )
	bs2b? ( media-libs/libbs2b )
	cdda? ( dev-libs/libcdio-paranoia )
	cue? ( media-libs/libcue )
	curl? ( net-misc/curl )
	dbus? ( sys-apps/dbus )
	aac? ( media-libs/faad2 )
	enca? ( app-i18n/enca )
	flac? ( media-libs/flac )
	game? ( media-libs/game-music-emu )
	ladspa? ( media-libs/ladspa-cmt )
	libsamplerate? ( media-libs/libsamplerate )
	mad? ( media-libs/libmad )
	midi? ( media-sound/wildmidi )
	mms? ( media-libs/libmms )
	mplayer? ( media-video/mplayer )
	mpris? ( dev-qt/qtdbus:4 )
	musepack? ( >=media-sound/musepack-tools-444 )
	modplug? ( >=media-libs/libmodplug-0.8.4 )
	vorbis? ( media-libs/libvorbis
		media-libs/libogg )
	jack? ( media-sound/jack-audio-connection-kit
		media-libs/libsamplerate )
	ffmpeg? ( virtual/ffmpeg )
	opus? ( media-libs/opusfile )
	projectm? ( media-libs/libprojectm
		dev-qt/qtopengl:4 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.9 )
	wavpack? ( media-sound/wavpack )
	scrobbler? ( net-misc/curl )
	sndfile? ( media-libs/libsndfile )
	udisks? ( sys-fs/udisks:2 )"
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog README"

CMAKE_IN_SOURCE_BUILD="1"

REQUIRED_USE="kde? ( dbus ) "

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
		-DUSE_alsa="$(usex alsa)"
		-DUSE_aac="$(usex aac)"
		-DUSE_analyzer="$(usex analyzer)"
		-DUSE_bs2b="$(usex bs2b)"
		-DUSE_CDA="$(usex cdda)"
		-DUSE_crossfade="$(usex crossfade)"
		-DUSE_cover="$(usex cover)"
		-DUSE_cue="$(usex cue)"
		-DUSE_curl="$(usex curl)"
		-DUSE_dbus="$(usex dbus)"
		-DUSE_enca="$(usex enca)"
		-DUSE_ffmpeg="$(usex ffmpeg)"
		-DUSE_FFMPEG_LEGACY=OFF
		-DUSE_flac="$(usex flac)"
		-DUSE_GME="$(usex game)"
		-DUSE_HAL=OFF
		-DUSE_jack="$(usex jack)"
		-DUSE_KDENOTIFY="$(usex kde)"
		-DUSE_ladspa="$(usex ladspa)"
		-DUSE_lyrics="$(usex lyrics)"
		-DUSE_mad="$(usex mad)"
		-DUSE_MIDI_WILDMIDI="$(usex midi)"
		-DUSE_mplayer="$(usex mplayer)"
		-DUSE_mms="$(usex mms)"
		-DUSE_modplug="$(usex modplug)"
		-DUSE_mpris="$(usex mpris)"
		-DUSE_MPC="$(usex musepack)"
		-DUSE_notifier="$(usex notifier)"
		-DUSE_opus="$(usex opus)"
		-DUSE_oss="$(usex oss)"
		-DUSE_projectm="$(usex projectm)"
		-DUSE_PULSE="$(usex pulseaudio)"
		-DUSE_qsui="$(usex qsui)"
		-DUSE_scrobbler="$(usex scrobbler)"
		-DUSE_sndfile="$(usex sndfile)"
		-DUSE_stereo="$(usex stereo)"
		-DUSE_STATICON="$(usex tray)"
		-DUSE_UDISKS2="$(usex udisks)"
		-DUSE_UDISKS=OFF
		-DUSE_SRC="$(usex libsamplerate)"
		-DUSE_vorbis="$(usex vorbis)"
		-DUSE_wavpack="$(usex wavpack)"
		)

	cmake-utils_src_configure
}
