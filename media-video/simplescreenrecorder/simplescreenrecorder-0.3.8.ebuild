# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic multilib-minimal

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
fi

DESCRIPTION="A Simple Screen Recorder"
HOMEPAGE="http://www.maartenbaert.be/simplescreenrecorder"
LICENSE="GPL-3"
PKGNAME="ssr"
if [[ ${PV} = 9999 ]] ; then
	EGIT_REPO_URI="git://github.com/MaartenBaert/${PKGNAME}.git
		https://github.com/MaartenBaert/${PKGNAME}.git"
	EGIT_BOOTSTRAP=""
else
	SRC_URI="https://github.com/MaartenBaert/${PKGNAME}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PKGNAME}-${PV}"
fi

SLOT="0"
IUSE="+asm debug jack mp3 pulseaudio theora vorbis vpx x264"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	media-libs/alsa-lib:0=
	media-libs/mesa[${MULTILIB_USEDEP}]
	|| (
		media-video/ffmpeg[vorbis?,vpx?,x264?,mp3?,theora?]
		media-video/libav[vorbis?,vpx?,x264?,mp3?,theora?]
	)
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXext
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	virtual/glu[${MULTILIB_USEDEP}]
	jack? ( virtual/jack )
	pulseaudio? ( media-sound/pulseaudio )
"
DEPEND="${RDEPEND}"

pkg_setup() {
	if [[ ${ABI} == amd64 ]]; then
		elog "You may want to add USE flag 'abi_x86_32' when running a 64bit system"
		elog "When added 32bit GLInject libraries are also included. This is"
		elog "required if you want to use OpenGL recording on 32bit applications."
		elog
	fi

	if { has_version media-video/ffmpeg[x264] || has_version media-video/libav[x264] ; } && has_version media-libs/x264[10bit] ; then
		ewarn
		ewarn "media-libs/x264 is currently built with 10bit useflag."
		ewarn "This is known to prevent simplescreenrecorder from recording x264 videos"
		ewarn "correctly. Please build media-libs/x264 without 10bit if you want to "
		ewarn "record videos with x264."
		ewarn
	fi

	# QT requires -fPIC. Compile fails otherwise.
	# Recently removed from the default compile options upstream
	# https://github.com/MaartenBaert/ssr/commit/25fe1743058f0d1f95f6fbb39014b6ac146b5180
	append-flags -fPIC
}

multilib_src_configure() {
	local myconf=(
		$(multilib_native_use_enable debug assert)
		$(multilib_native_use_with pulseaudio)
		$(multilib_native_use_with jack)
		$(use_enable asm x86-asm)
	)

	# libav doesn't have AVFrame::channels
	# https://github.com/MaartenBaert/ssr/issues/195#issuecomment-45646159
	if has_version media-video/libav; then
		myconf+=( --disable-ffmpeg-versions )
	fi

	if multilib_is_native_abi ; then
		myconf+=( --with-qt5 )
	else
		myconf+=( --disable-ssrprogram )
	fi

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}
