# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils gnome2-utils toolchain-funcs qmake-utils games

MY_P=${PN}_v${PV}-source

DESCRIPTION="A Nintendo multi-system emulator formerly known as bsnes"
HOMEPAGE="http://byuu.org/higan/ https://code.google.com/p/higan/"
SRC_URI="http://download.byuu.org/${MY_P}.7z"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ao +alsa +icarus openal opengl oss pulseaudio qt4 +sdl udev xv"
REQUIRED_USE="|| ( ao openal alsa pulseaudio oss )
	|| ( xv opengl sdl )"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	ao? ( media-libs/libao )
	openal? ( media-libs/openal )
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
	xv? ( x11-libs/libXv )
	opengl? ( virtual/opengl )
	sdl? ( media-libs/libsdl[X,joystick,video] )
	udev? ( virtual/udev )
	!qt4? ( x11-libs/gtk+:2 )
	qt4? ( >=dev-qt/qtgui-4.5:4 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

disable_module() {
	sed -i \
		-e "s|$1\b||" \
		"${S}"/higan/target-tomoko/GNUmakefile || die
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-QA.patch

	sed -i \
		-e "/handle/s#/usr/local/lib#/usr/$(get_libdir)#" \
		nall/dl.hpp || die "fixing libdir failed!"

	# audio modules
	use ao || disable_module audio.ao
	use openal || disable_module audio.openal
	use pulseaudio ||  { disable_module audio.pulseaudio
		disable_module audio.pulseaudiosimple ;}
	use oss || disable_module audio.oss
	use alsa || disable_module audio.alsa

	# video modules
	use opengl || disable_module video.glx
	use xv || disable_module video.xv
	use sdl || disable_module video.sdl

	# input modules
	use sdl || disable_module input.sdl
	use udev || disable_module input.udev

	# regenerate .moc if needed
	if use qt4; then
		cd hiro/qt || die
		 "$(qt4_get_bindir)"/moc -i -I. -o qt.moc qt.hpp || die
	fi
}

src_compile() {
	local mytoolkit

	if use qt4; then
		mytoolkit="qt"
	else
		mytoolkit="gtk"
	fi

	if use icarus; then
		cd "${S}/icarus" || die
		emake \
			platform="linux" \
			compiler="$(tc-getCXX)"
	fi

	cd "${S}/higan" || die
	emake \
		platform="linux" \
		compiler="$(tc-getCXX)" \
		hiro="${mytoolkit}"

	sed \
		-e "s:%GAMES_DATADIR%:${GAMES_DATADIR}:" \
		< "${FILESDIR}"/${PN}-wrapper \
		> out/${PN}-wrapper || die "generating wrapper failed!"
}

src_install() {
	if use icarus; then
		newgamesbin "${S}"/icarus/out/icarus icarus
	fi
	newgamesbin "${S}"/higan/out/${PN} ${PN}.bin
	newgamesbin "${S}"/higan/out/${PN}-wrapper ${PN}
	make_desktop_entry "${PN}" "${PN}"

	# copy home directory stuff to a global location
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r higan/data/cheats.bml higan/profile/*

	doicon -s 512 higan/data/${PN}.png

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	#elog "optional dependencies:"
	#elog "  dev-games/higan-ananke (extra rom load options)"
	#elog "  games-util/higan-purify (Rom purifier)"

	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
