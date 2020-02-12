# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils git-r3 xdg-utils

DESCRIPTION="PCSX-Reloaded: a fork of PCSX, the discontinued Playstation emulator"
HOMEPAGE="https://github.com/iCatButler/pcsxr"
EGIT_REPO_URI="https://github.com/iCatButler/pcsxr"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS=""

IUSE="alsa archive ccdda cdio libav openal oss pulseaudio +sdl"
REQUIRED_USE="?? ( alsa openal oss pulseaudio sdl )"

RDEPEND="
	dev-libs/glib:2
	media-libs/libsdl2[joystick]
	sys-libs/zlib:=
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXtst
	x11-libs/libXv
	x11-libs/libXxf86vm
	virtual/libintl
	virtual/opengl
	archive? ( app-arch/libarchive:= )
	alsa? ( media-libs/alsa-lib:= )
	cdio? ( dev-libs/libcdio:= )
	ccdda? (
		!libav? ( >=media-video/ffmpeg-3:= )
		libav? ( media-video/libav:= )
	)
	openal? ( media-libs/openal:= )
	pulseaudio? ( media-sound/pulseaudio:= )
	sdl? ( media-libs/libsdl2:=[sound] )
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	app-arch/unzip
	dev-util/intltool
	sys-devel/gettext:0
"

src_configure() {
	local sound_backend

	if use pulseaudio; then
		sound_backend=pulse
	elif use sdl; then
		sound_backend=sdl
	elif use openal; then
		sound_backend=openal
	elif use alsa; then
		sound_backend=alsa
	elif use oss; then
		sound_backend=oss
	else
		sound_backend=null
	fi

	local mycmakeargs=(
		-DENABLE_CCDDA=$(usex ccdda)
		-DUSE_LIBARCHIVE=$(usex archive)
		-DUSE_LIBCDIO=$(usex cdio)
		-DSND_BACKEND=${sound_backend}
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	mv "${ED}"/usr/share/doc/pcsxr/* "${ED}/usr/share/doc/${PF}/" || die
	rmdir "${ED}"/usr/share/doc/pcsxr || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
