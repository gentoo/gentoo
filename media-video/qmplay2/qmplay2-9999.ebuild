# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="A Qt-based video player, which can play most formats and codecs"
HOMEPAGE="https://github.com/zaps166/QMPlay2"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zaps166/QMPlay2"
else
	SRC_URI="https://github.com/zaps166/QMPlay2/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/QMPlay2-${PV}"
fi

LICENSE="LGPL-3"
SLOT="0"

IUSE="avdevice +audiofilters avresample +alsa cdio cuvid dbus +extensions
	+ffmpeg gme inputs +lastfm libass lyrics mediabrowser modplug mpris2
	notifications opengl portaudio pulseaudio sid svg taglib vaapi vdpau
	+videofilters visualizations xv"

REQUIRED_USE="
	audiofilters? ( || ( alsa portaudio pulseaudio ) )
	avdevice? ( ffmpeg )
	avresample? ( ffmpeg )
	lastfm? ( extensions )
	lyrics? ( extensions )
	mediabrowser? ( extensions )
	mpris2? ( extensions dbus )
	vaapi? ( ffmpeg opengl )
	vdpau? ( ffmpeg )"

RDEPEND="
	alsa? ( media-libs/alsa-lib )
	cdio? ( dev-libs/libcdio[cddb] )
	dev-libs/jansson
	dev-qt/qtcore:5
	dev-qt/qtgui:5[xcb]
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dbus? ( dev-qt/qtdbus:5 )
	ffmpeg? ( media-video/ffmpeg )
	gme? ( media-libs/game-music-emu )
	libass? ( media-libs/libass )
	mediabrowser? ( dev-qt/qtdeclarative:5 )
	opengl? ( virtual/opengl )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	sid? ( media-libs/libsidplayfp )
	svg? ( dev-qt/qtsvg:5 )
	taglib? ( media-libs/taglib )
	vaapi? (
		>=media-video/ffmpeg-4.1.0[vaapi]
		x11-libs/libva[drm,opengl] )
	vdpau? ( media-video/ffmpeg[vdpau] )
	xv? ( x11-libs/libXv )"

DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig"

src_prepare() {
	# disable compress man pages
	sed -r \
		-e 's/if\(GZIP\)/if\(TRUE\)/' \
		-e 's/(install.+QMPlay2\.1)\.gz/\1/' \
		-i src/gui/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# core
		-DUSE_ALSA=$(usex alsa)
		-DUSE_AUDIOCD=$(usex cdio)
		-DUSE_AVRESAMPLE=$(usex avresample)
		-DUSE_FREEDESKTOP_NOTIFICATIONS=$(usex dbus) # https://github.com/zaps166/QMPlay2/issues/134
		-DUSE_LIBASS=$(usex libass)
		-DUSE_NOTIFY=$(usex notifications)
		-DUSE_OPENGL2=$(usex opengl)
		-DUSE_XVIDEO=$(usex xv)

		# ffmpeg
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_FFMPEG_AVDEVICE=$(usex avdevice)
		-DUSE_FFMPEG_VAAPI=$(usex vaapi)
		-DUSE_FFMPEG_VDPAU=$(usex vdpau)

		# modules
		-DUSE_AUDIOFILTERS=$(usex audiofilters)
		-DUSE_CUVID=$(usex cuvid)
		-DUSE_EXTENSIONS=$(usex extensions)
		-DUSE_INPUTS=$(usex inputs)
		-DUSE_MODPLUG=$(usex modplug)
		-DUSE_PORTAUDIO=$(usex portaudio)
		-DUSE_PULSEAUDIO=$(usex pulseaudio)
		-DUSE_VIDEOFILTERS=$(usex videofilters)
		-DUSE_VISUALIZATIONS=$(usex visualizations)

		# gui
		-DUSE_TAGLIB=$(usex taglib)

		# chiptune
		-DUSE_CHIPTUNE_GME=$(usex gme)
		-DUSE_CHIPTUNE_SID=$(usex sid)

		# extensions
		-DUSE_LASTFM=$(usex lastfm)
		-DUSE_LYRICS=$(usex lyrics)
		-DUSE_MEDIABROWSER=$(usex mediabrowser)
		-DUSE_MPRIS2=$(usex mpris2)
	)

	if [[ ${PV} == *9999 ]]; then
		mycmakeargs+=( USE_GIT_VERSION=ON )
	else
		mycmakeargs+=( USE_GIT_VERSION=OFF )
	fi

	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
