# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic xdg cmake

EGIT_COMMIT="62467b86871aee3d70c7445f3cb79f0858ec566e"
MY_P=${PN}-${EGIT_COMMIT}
DESCRIPTION="PCSX-Reloaded: a fork of PCSX, the discontinued Playstation emulator"
HOMEPAGE="https://github.com/iCatButler/pcsxr"
SRC_URI="https://github.com/iCatButler/pcsxr/archive/${EGIT_COMMIT}.tar.gz -> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="~amd64"

IUSE="alsa archive ccdda cdio openal oss pulseaudio +sdl"
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
	ccdda? ( >=media-video/ffmpeg-3:= )
	openal? ( media-libs/openal:= )
	pulseaudio? ( media-sound/pulseaudio:= )
	sdl? ( media-libs/libsdl2:=[sound] )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	app-arch/unzip
	dev-util/intltool
	sys-devel/gettext:0"

src_configure() {
	append-cflags -fcommon
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

	cmake_src_configure
}

src_install() {
	cmake_src_install
	mv "${ED}"/usr/share/doc/pcsxr/* "${ED}/usr/share/doc/${PF}/" || die
	rmdir "${ED}"/usr/share/doc/pcsxr || die
}
