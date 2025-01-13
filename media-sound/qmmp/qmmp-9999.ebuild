# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Qt-based audio player with winamp/xmms skins support"
HOMEPAGE="https://qmmp.ylsoftware.com"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://qmmp.ylsoftware.com/files/${PN}/$(ver_cut 1-2)/${P}.tar.bz2
		https://downloads.sourceforge.net/${PN}-dev/files/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	inherit subversion
	QMMP_DEV_BRANCH="2.2"
	ESVN_REPO_URI="svn://svn.code.sf.net/p/${PN}-dev/code/branches/${PN}-${QMMP_DEV_BRANCH}"
fi

LICENSE="GPL-2"
SLOT="0"
# KEYWORDS further up
IUSE="aac +alsa analyzer archive bs2b cdda cover crossfade cue curl +dbus enca
ffmpeg flac game gnome jack ladspa libxmp lyrics +mad midi mms mplayer musepack
notifier opus oss pipewire projectm pulseaudio qsui qtmedia scrobbler shout sid
sndfile soxr stereo tray udisks +vorbis wavpack"

REQUIRED_USE="
	gnome? ( dbus )
	shout? ( soxr vorbis )
	udisks? ( dbus )
"

RDEPEND="
	dev-qt/qtbase:6[X,dbus,gui,network,sqlite,widgets]
	media-libs/taglib:=
	x11-libs/libX11
	aac? ( media-libs/faad2 )
	alsa? ( media-libs/alsa-lib )
	archive? ( app-arch/libarchive )
	bs2b? ( media-libs/libbs2b )
	cdda? (
		dev-libs/libcdio:=
		dev-libs/libcdio-paranoia
	)
	curl? ( net-misc/curl )
	dbus? ( dev-qt/qtbase:6[dbus] )
	enca? ( app-i18n/enca )
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac:= )
	game? ( media-libs/game-music-emu )
	jack? (
		media-libs/libsamplerate
		virtual/jack
	)
	ladspa? ( media-plugins/cmt-plugins )
	libxmp? ( media-libs/libxmp )
	mad? (
		media-libs/libmad:=
		media-sound/mpg123:=
	)
	midi? ( media-sound/wildmidi )
	mms? ( media-libs/libmms )
	mplayer? ( media-video/mplayer )
	musepack? ( >=media-sound/musepack-tools-444 )
	opus? ( media-libs/opusfile )
	pipewire? ( media-video/pipewire )
	projectm? (
		dev-qt/qtbase:6[-gles2-only,opengl]
		media-libs/libprojectm:=
	)
	pulseaudio? ( media-libs/libpulse )
	qtmedia? ( dev-qt/qtmultimedia:6 )
	scrobbler? ( net-misc/curl )
	shout? ( media-libs/libshout )
	sid? ( >=media-libs/libsidplayfp-1.1.0 )
	sndfile? ( media-libs/libsndfile )
	soxr? ( media-libs/soxr )
	udisks? ( sys-fs/udisks:2 )
	vorbis? (
		media-libs/libogg
		media-libs/libvorbis
	)
	wavpack? ( media-sound/wavpack )
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

DOCS=( AUTHORS ChangeLog README )

src_prepare() {
	if has_version dev-libs/libcdio-paranoia ; then
		sed -i \
			-e 's:cdio/cdda.h:cdio/paranoia/cdda.h:' \
			src/plugins/Input/cdaudio/decoder_cdaudio.cpp || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUSE_AAC="$(usex aac)"
		-DUSE_ALSA="$(usex alsa)"
		-DUSE_ANALYZER="$(usex analyzer)"
		-DUSE_ARCHIVE="$(usex archive)"
		-DUSE_BS2B="$(usex bs2b)"
		-DUSE_CDA="$(usex cdda)"
		-DUSE_COVER="$(usex cover)"
		-DUSE_CROSSFADE="$(usex crossfade)"
		-DUSE_CUE="$(usex cue)"
		-DUSE_CURL="$(usex curl)"
		-DUSE_KDENOTIFY="$(usex dbus)"
		-DUSE_MPRIS="$(usex dbus)"
		-DUSE_ENCA="$(usex enca)"
		-DUSE_FFMPEG="$(usex ffmpeg)"
		-DUSE_FILEWRITER="$(usex vorbis)"
		-DUSE_FLAC="$(usex flac)"
		-DUSE_GME="$(usex game)"
		-DUSE_GNOMEHOTKEY="$(usex gnome)"
		-DUSE_JACK="$(usex jack)"
		-DUSE_LADSPA="$(usex ladspa)"
		-DUSE_LYRICS="$(usex lyrics)"
		-DUSE_MAD="$(usex mad)"
		-DUSE_MIDI="$(usex midi)"
		-DUSE_MMS="$(usex mms)"
		-DUSE_MPLAYER="$(usex mplayer)"
		-DUSE_MPC="$(usex musepack)"
		-DUSE_NOTIFIER="$(usex notifier)"
		-DUSE_OPUS="$(usex opus)"
		-DUSE_OSS="$(usex oss)"
		-DUSE_PIPEWIRE="$(usex pipewire)"
		-DUSE_PROJECTM="$(usex projectm)"
		-DUSE_PULSE="$(usex pulseaudio)"
		-DUSE_QSUI="$(usex qsui)"
		-DUSE_QTMULTIMEDIA="$(usex qtmedia)"
		-DUSE_SCROBBLER="$(usex scrobbler)"
		-DUSE_SHOUT="$(usex shout)"
		-DUSE_SID="$(usex sid)"
		-DUSE_SNDFILE="$(usex sndfile)"
		-DUSE_SOXR="$(usex soxr)"
		-DUSE_STEREO="$(usex stereo)"
		-DUSE_STATICON="$(usex tray)"
		-DUSE_UDISKS="$(usex udisks)"
		-DUSE_VORBIS="$(usex vorbis)"
		-DUSE_WAVPACK="$(usex wavpack)"
		-DUSE_XMP="$(usex libxmp)"
	)

	cmake_src_configure
}
