# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils games

DESCRIPTION="PCSX-Reloaded: a fork of PCSX, the discontinued Playstation emulator"
HOMEPAGE="http://pcsxr.codeplex.com"
# codeplex doesn't support direct downloads but GPL-2 doesn't mind me
# mirroring it.
SRC_URI="http://dev.gentoo.org/~mgorny/dist/${P}.zip"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa cdio ffmpeg nls openal opengl oss pulseaudio +sdl"

# pcsxr supports both SDL1 and SDL2 but uses the newer version installed
# since SDL is not properly slotted in Gentoo, just fix it on SDL2

RDEPEND="dev-libs/glib:2=
	media-libs/libsdl:0=[joystick]
	sys-libs/zlib:0=
	x11-libs/gtk+:3=
	x11-libs/libX11:0=
	x11-libs/libXext:0=
	x11-libs/libXtst:0=
	x11-libs/libXv:0=
	alsa? ( media-libs/alsa-lib:0= )
	cdio? ( dev-libs/libcdio:0= )
	ffmpeg? ( virtual/ffmpeg:0= )
	nls? ( virtual/libintl:0= )
	openal? ( media-libs/openal:0= )
	opengl? ( virtual/opengl:0=
		x11-libs/libXxf86vm:0= )
	pulseaudio? ( media-sound/pulseaudio:0= )
	sdl? ( media-libs/libsdl:0=[sound] )"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-util/intltool
	x11-proto/videoproto
	nls? ( sys-devel/gettext:0 )
	x86? ( dev-lang/nasm )"

REQUIRED_USE="?? ( alsa openal oss pulseaudio sdl )"

# it's only the .po file check that fails :)
RESTRICT=test

S=${WORKDIR}/${PN}

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${P}-disable-sdl2.patch
		"${FILESDIR}"/${P}-install-paths.patch
	)

	epatch "${PATCHES[@]}"
	epatch_user
	eautoreconf
}

src_configure() {
	local sound_backend

	if use alsa; then
		sound_backend=alsa
	elif use oss; then
		sound_backend=oss
	elif use pulseaudio; then
		sound_backend=pulseaudio
	elif use sdl; then
		sound_backend=sdl
	elif use openal; then
		sound_backend=openal
	else
		sound_backend=null
	fi

	local myeconfargs=(
		--datarootdir="${EPREFIX%/}"/usr/share

		$(use_enable nls)
		$(use_enable cdio libcdio)
		$(use_enable opengl)
		$(use_enable ffmpeg ccdda)
		--enable-sound=${sound_backend}
	)

	egamesconf "${myeconfargs[@]}"
}

src_install() {
	default
	prune_libtool_files --all

	dodoc doc/{keys,tweaks}.txt
	prepgamesdirs
}
