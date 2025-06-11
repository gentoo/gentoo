# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="ssr"
inherit cmake-multilib xdg

DESCRIPTION="Simple Screen Recorder"
HOMEPAGE="https://www.maartenbaert.be/simplescreenrecorder/"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/MaartenBaert/${MY_PN}.git"
	EGIT_BOOTSTRAP=""
	inherit git-r3
else
	SRC_URI="https://github.com/MaartenBaert/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_PN}-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="+asm jack mp3 opengl pulseaudio theora screencast v4l vorbis vpx x264"

REQUIRED_USE="abi_x86_32? ( opengl )"

RDEPEND="
	dev-qt/qtbase:6[gui,widgets]
	media-libs/alsa-lib:0=
	media-video/ffmpeg:=[theora?,vorbis?,vpx?,x264?]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXext
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	x11-libs/libXi
	x11-libs/libXinerama
	virtual/glu[${MULTILIB_USEDEP}]
	jack? ( virtual/jack )
	mp3? ( media-video/ffmpeg[lame(-)] )
	opengl? ( media-libs/libglvnd[${MULTILIB_USEDEP},X] )
	pulseaudio? ( media-libs/libpulse )
	screencast? ( media-video/pipewire:= )
	v4l? ( media-libs/libv4l )
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

pkg_pretend() {
	if use amd64 && ! use abi_x86_32 ; then
		einfo "You may want to add USE flag 'abi_x86_32' when running a 64bit system"
		einfo "When added 32bit GLInject libraries are also included. This is"
		einfo "required if you want to use OpenGL recording on 32bit applications."
		einfo
	fi

	if has_version media-video/ffmpeg[x264] && has_version media-libs/x264[10bit] ; then
		ewarn
		ewarn "media-libs/x264 is currently built with 10bit useflag."
		ewarn "This is known to prevent simplescreenrecorder from recording x264 videos"
		ewarn "correctly. Please build media-libs/x264 without 10bit if you want to "
		ewarn "record videos with x264."
		ewarn
	fi
}

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_JACK_METADATA="$(multilib_native_usex jack)"
		-DENABLE_X86_ASM="$(usex asm)"
		-DWITH_OPENGL_RECORDING="$(usex opengl)"
		-DWITH_PULSEAUDIO="$(multilib_native_usex pulseaudio)"
		-DWITH_PIPEWIRE="$(multilib_native_usex screencast)"
		-DWITH_JACK="$(multilib_native_usex jack)"
		-DWITH_GLINJECT="$(usex opengl)"
		-DWITH_V4L2="$(multilib_native_usex v4l)"
	)

	if multilib_is_native_abi ; then
		mycmakeargs+=(
			-DENABLE_32BIT_GLINJECT="false"
			-DWITH_QT6=ON
		)
	else
		mycmakeargs+=(
			# https://bugs.gentoo.org/660438
			-DCMAKE_INSTALL_LIB32DIR="$(get_libdir)"
			-DENABLE_32BIT_GLINJECT="true"
			-DWITH_SIMPLESCREENRECORDER="false"
		)
	fi

	cmake_src_configure
}
