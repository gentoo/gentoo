# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_ECLASS=cmake
inherit cmake-multilib flag-o-matic xdg

DESCRIPTION="A Simple Screen Recorder"
HOMEPAGE="https://www.maartenbaert.be/simplescreenrecorder"
LICENSE="GPL-3"
PKGNAME="ssr"
if [[ ${PV} = 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/MaartenBaert/${PKGNAME}.git"
	EGIT_BOOTSTRAP=""
else
	SRC_URI="https://github.com/MaartenBaert/${PKGNAME}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PKGNAME}-${PV}"
fi

SLOT="0"
IUSE="+asm jack mp3 opengl pulseaudio theora v4l vorbis vpx x264"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	media-libs/alsa-lib:0=
	media-video/ffmpeg[vorbis?,vpx?,x264?,mp3?,theora?]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXext
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	x11-libs/libXi
	x11-libs/libXinerama
	virtual/glu[${MULTILIB_USEDEP}]
	v4l? ( media-libs/libv4l )
	jack? ( virtual/jack )
	opengl? ( media-libs/libglvnd[${MULTILIB_USEDEP},X] )
	pulseaudio? ( media-sound/pulseaudio )
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

REQUIRED_USE="abi_x86_32? ( opengl )"

pkg_pretend() {
	if [[ "${ABI}" == amd64 ]] ; then
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

pkg_setup() {
	# QT requires -fPIC. Compile fails otherwise.
	# Recently removed from the default compile options upstream
	# https://github.com/MaartenBaert/ssr/commit/25fe1743058f0d1f95f6fbb39014b6ac146b5180
	append-flags -fPIC
}

src_prepare() {
	# required because xdg.eclass overrides default cmake_src_prepare
	cmake_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_JACK_METADATA="$(multilib_native_usex jack)"
		-DENABLE_X86_ASM="$(usex asm)"
		-DWITH_OPENGL_RECORDING="$(usex opengl)"
		-DWITH_PULSEAUDIO="$(multilib_native_usex pulseaudio)"
		-DWITH_JACK="$(multilib_native_usex jack)"
		-DWITH_GLINJECT="$(usex opengl)"
		-DWITH_V4L2="$(multilib_native_usex v4l)"
	)

	if multilib_is_native_abi ; then
		mycmakeargs+=(
			-DENABLE_32BIT_GLINJECT="false"
			-DWITH_QT5="true"
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
