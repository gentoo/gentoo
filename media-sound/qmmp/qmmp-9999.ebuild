# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Qt5-based audio player with winamp/xmms skins support"
HOMEPAGE="http://qmmp.ylsoftware.com"
if [[ ${PV} != 9999 ]]; then
	SRC_URI="http://qmmp.ylsoftware.com/files/${P}.tar.bz2
		mirror://sourceforge/${PN}-dev/files/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	inherit subversion
	QMMP_DEV_BRANCH="1.3"
	ESVN_REPO_URI="svn://svn.code.sf.net/p/${PN}-dev/code/branches/${PN}-${QMMP_DEV_BRANCH}"
fi

LICENSE="GPL-2"
SLOT="0"
# KEYWORDS further up
IUSE="aac +alsa analyzer archive bs2b cdda cover crossfade cue curl +dbus enca
ffmpeg flac game gnome jack ladspa lyrics +mad midi mms mplayer musepack
notifier opus oss pipewire projectm pulseaudio qsui qtmedia scrobbler shout sid
sndfile soxr stereo tray udisks +vorbis wavpack xmp"

REQUIRED_USE="
	gnome? ( dbus )
	shout? ( soxr vorbis )
	udisks? ( dbus )
"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	media-libs/taglib
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
	dbus? ( dev-qt/qtdbus:5 )
	enca? ( app-i18n/enca )
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac )
	game? ( media-libs/game-music-emu )
	jack? (
		media-libs/libsamplerate
		virtual/jack
	)
	ladspa? ( media-plugins/cmt-plugins )
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
		dev-qt/qtgui:5[-gles2-only]
		dev-qt/qtopengl:5
		media-libs/libprojectm:=
	)
	pulseaudio? ( >=media-sound/pulseaudio-0.9.9 )
	qtmedia? ( dev-qt/qtmultimedia:5 )
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
	xmp? ( media-libs/libxmp )
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

DOCS=( AUTHORS ChangeLog README )

PATCHES=(
	"${FILESDIR}/${PN}-1.6.0-udisks_plugin.patch"
)

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
		-DUSE_XMP="$(usex xmp)"
	)

	cmake_src_configure
}
