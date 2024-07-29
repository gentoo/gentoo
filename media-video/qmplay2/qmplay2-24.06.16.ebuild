# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="A Qt-based video player, which can play most formats and codecs"
HOMEPAGE="https://github.com/zaps166/QMPlay2"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zaps166/QMPlay2"
else
	SRC_URI="https://github.com/zaps166/QMPlay2/releases/download/${PV}/QMPlay2-src-${PV}.tar.xz"
	S="${WORKDIR}/QMPlay2-src-${PV}"
	KEYWORDS="amd64"
fi

LICENSE="LGPL-3"
SLOT="0"

IUSE="avdevice +audiofilters +alsa cdio cuvid extensions gme inputs libass
	modplug notifications opengl pipewire portaudio pulseaudio qt6 sid
	shaders +taglib vaapi videofilters visualizations vulkan xv"

REQUIRED_USE="
	audiofilters? ( || ( alsa pipewire portaudio pulseaudio ) )
	shaders? ( vulkan )
"

RDEPEND="
	media-video/ffmpeg:=[vaapi?]
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5[X(-),vulkan?]
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
		extensions? ( dev-qt/qtdeclarative:5 )
		videofilters? ( dev-qt/qtconcurrent:5 )
	)
	qt6? (
		dev-qt/qtbase:6[concurrent,dbus,gui,network,opengl?,ssl,vulkan?,widgets]
		dev-qt/qt5compat:6
		dev-qt/qtsvg:6
		extensions? ( dev-qt/qtdeclarative:6 )
	)
	alsa? ( media-libs/alsa-lib )
	cdio? ( dev-libs/libcdio[cddb] )
	gme? ( media-libs/game-music-emu )
	libass? ( media-libs/libass )
	opengl? ( virtual/opengl )
	pipewire? ( media-video/pipewire )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-libs/libpulse )
	sid? ( media-libs/libsidplayfp )
	shaders? ( >=media-libs/shaderc-2020.1 )
	taglib? ( media-libs/taglib	)
	vaapi? ( media-libs/libva[X] )
	vulkan? ( >=media-libs/vulkan-loader-1.2.133 )
	xv? ( x11-libs/libXv )
"
DEPEND="${RDEPEND}"
BDEPEND="
	!qt6? ( dev-qt/linguist-tools:5 )
	qt6? ( dev-qt/qttools:6[linguist] )
"

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
		-DBUILD_WITH_QT6=$(usex qt6)
		# core
		-DUSE_UPDATES=OFF
		-DUSE_ALSA=$(usex alsa)
		-DUSE_AUDIOCD=$(usex cdio)
		-DUSE_DBUS_PM=ON
		-DUSE_FREEDESKTOP_NOTIFICATIONS=ON
		-DUSE_LIBASS=$(usex libass)
		-DUSE_NOTIFY=$(usex notifications)
		-DUSE_OPENGL=$(usex opengl)
		-DUSE_VULKAN=$(usex vulkan)
		-DUSE_GLSLC=$(usex shaders)
		-DUSE_XVIDEO=$(usex xv)

		# ffmpeg
		-DUSE_FFMPEG_AVDEVICE=$(usex avdevice)
		-DUSE_FFMPEG_VAAPI=$(usex vaapi)

		# chiptune
		-DUSE_CHIPTUNE_GME=$(usex gme)
		-DUSE_CHIPTUNE_SID=$(usex sid)

		# modules
		-DUSE_AUDIOFILTERS=$(usex audiofilters)
		-DUSE_CUVID=$(usex cuvid)
		-DUSE_INPUTS=$(usex inputs)
		-DUSE_MODPLUG=$(usex modplug)
		-DUSE_PIPEWIRE=$(usex pipewire)
		-DUSE_PORTAUDIO=$(usex portaudio)
		-DUSE_PULSEAUDIO=$(usex pulseaudio)
		-DUSE_TAGLIB=$(usex taglib)
		-DUSE_VIDEOFILTERS=$(usex videofilters)
		-DUSE_VISUALIZATIONS=$(usex visualizations)

		# extensions
		-DUSE_EXTENSIONS=$(usex extensions)
	)

	if use extensions; then
		# Move inside an if, to remove unused option warning
		mycmakeargs+=(
			-DUSE_LASTFM=ON
			-DUSE_LYRICS=ON
			-DUSE_MEDIABROWSER=ON
			-DUSE_MPRIS2=ON
		)
	fi

	if [[ ${PV} == *9999 ]]; then
		mycmakeargs+=( -DUSE_GIT_VERSION=true )
	else
		mycmakeargs+=( -DUSE_GIT_VERSION=false )
	fi

	cmake_src_configure
}
