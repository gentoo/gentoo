# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# docs should be migrated to cmake
DOCS_BUILDER=doxygen
DOCS_DIR="${S}"/doc

inherit cmake docs xdg

DESCRIPTION="Qt6-based audio player with winamp/xmms skins support"
HOMEPAGE="https://qmmp.ylsoftware.com"
if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://qmmp.ylsoftware.com/files/${PN}/$(ver_cut 1-2)/${P}.tar.bz2
		https://downloads.sourceforge.net/${PN}-dev/files/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	inherit subversion
	local BRANCH_VER="2.2" # NOTE: bump this to $(ver_cut 1-2) for live ebuild
	ESVN_REPO_URI="svn://svn.code.sf.net/p/qmmp-dev/code/branches/${PN}-${BRANCH_VER}"
fi

LICENSE="CC-BY-SA-4.0 GPL-2+" # default skin & source code
SLOT="0"
# KEYWORDS further up
IUSE="X aac +alsa analyzer archive bs2b cdda cddb cover crossfade cue curl +dbus
enca ffmpeg flac game gnome jack ladspa libxmp lyrics +mad midi mms mpg123
mplayer musepack notifier opus oss pipewire projectm pulseaudio qsui qtmedia
scrobbler shout sid sndfile soxr stereo tray udisks +vorbis wavpack"

REQUIRED_USE="
	cddb? ( cdda )
	gnome? ( dbus )
	notifier? ( X )
	shout? ( soxr vorbis )
	udisks? ( dbus )
"

RDEPEND="
	dev-qt/qtbase:6[X?,dbus?,gui,network,sqlite,widgets]
	media-libs/taglib:=
	X? ( x11-libs/libX11 )
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
		media-libs/libprojectm:=
	)
	pulseaudio? ( media-libs/libpulse )
	qtmedia? ( dev-qt/qtmultimedia:6 )
	scrobbler? ( net-misc/curl )
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
BDEPEND="dev-qt/qttools:6[linguist]"

DOCS=( AUTHORS ChangeLog README )

PATCHES=( "${FILESDIR}"/${P}_build-with-projectm4.patch )

src_configure() {
	local mycmakeargs=( # listed in readme
		# potential USE flags
		-DUSE_LIBRCD=OFF
		-DUSE_OSS4=OFF

		# explicit defaults
		-DUSE_COPYPASTE=ON
		-DUSE_DIR_ASSOC=ON
		-DUSE_FILEOPS=ON
		-DUSE_MONOTOSTEREO=ON
		-DUSE_NULL=ON
		-DUSE_QMMP_DIALOG=ON
		-DUSE_TRACKCHANGE=ON
		-DUSE_TWO_PANEL_DIALOG=ON

		# our defaults
		-DUSE_CONVERTER=ON # because taglib
		-DUSE_RGSCAN=ON # because taglib
		-DUSE_LIBRARY=ON # because qtbase[sqlite]

		# turn off windows specific stuff
		-DUSE_DSOUND=OFF
		-DUSE_TASKBAR=OFF
		-DUSE_RDETECT=OFF
		-DUSE_WASAPI=OFF
		-DUSE_WAVEOUT=OFF

		# set USE flags
		-DUSE_AAC="$(usex aac)"
		-DUSE_ALSA="$(usex alsa)"
		-DUSE_ANALYZER="$(usex analyzer)"
		-DUSE_ARCHIVE="$(usex archive)"
		-DUSE_BS2B="$(usex bs2b)"
		-DUSE_CDA="$(usex cdda)"
		-DUSE_LIBCDDB="$(usex cddb)"
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
		-DUSE_HOTKEY="$(usex X)"
		-DUSE_JACK="$(usex jack)"
		-DUSE_LADSPA="$(usex ladspa)"
		-DUSE_LYRICS="$(usex lyrics)"
		-DUSE_MAD="$(usex mad)"
		-DUSE_MIDI="$(usex midi)"
		-DUSE_MMS="$(usex mms)"
		-DUSE_MPG123="$(usex mpg123)"
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
		-DUSE_SKINNED="$(usex X)"
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

src_compile() {
	cmake_src_compile
	docs_compile
}

src_install() {
	cmake_src_install
	if use doc; then #
		mv "${ED}"/usr/share/doc/${PF}/html/{doxygen/,./} || die
		rmdir "${ED}"/usr/share/doc/${PF}/html/doxygen || die
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
