# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils toolchain-funcs qmake-utils

MY_COMMIT=41efdba45afa770db99bc7484a8ad340ccc597d2

DESCRIPTION="A multi-system game emulator formerly known as bsnes"
HOMEPAGE="https://byuu.org/emulation/higan/ https://gitlab.com/higan/higan"
SRC_URI="https://gitlab.com/higan/higan/repository/${MY_COMMIT}/archive.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ao +alsa +icarus openal opengl oss pulseaudio +sdl udev xv"
REQUIRED_USE="|| ( ao openal alsa pulseaudio oss )
	|| ( xv opengl sdl )"

RDEPEND="
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXext
	icarus? ( x11-libs/gtksourceview:2.0
			  x11-libs/gtk+:2
			  x11-libs/pango
			  dev-libs/atk
			  x11-libs/cairo
			  x11-libs/gdk-pixbuf
			  dev-libs/glib:2
			  media-libs/fontconfig
			  media-libs/freetype
			)
	ao? ( media-libs/libao )
	openal? ( media-libs/openal )
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
	xv? ( x11-libs/libXv )
	opengl? ( virtual/opengl )
	sdl? ( media-libs/libsdl[X,joystick,video] )
	udev? ( virtual/udev )
"
DEPEND="${RDEPEND}
	app-arch/p7zip
	virtual/pkgconfig"

S=${WORKDIR}/${PN}-${MY_COMMIT}-${MY_COMMIT}

disable_module() {
	sed -i \
		-e "s|$1\b||" \
		"${S}"/higan/target-tomoko/GNUmakefile || die
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-header-locations.patch
	epatch "${FILESDIR}"/${P}-QA.patch

	sed -i \
		-e "/handle/s#/usr/local/lib#/usr/$(get_libdir)#" \
		nall/dl.hpp || die "fixing libdir failed!"

	eapply_user

	# audio modules
	use ao || disable_module audio.ao
	use openal || disable_module audio.openal
	use pulseaudio ||  { disable_module audio.pulseaudio
		disable_module audio.pulseaudiosimple ;}
	use oss || disable_module audio.oss
	use alsa || disable_module audio.alsa

	# video modules
	use opengl || disable_module video.glx
	use xv || disable_module video.xvideo
	use sdl || disable_module video.sdl

	# input modules
	use sdl || disable_module input.sdl
	use udev || disable_module input.udev
}

src_compile() {
	local mytoolkit

	mytoolkit="gtk"

	# Needed for fluent audio (even on i5 hardware)
	export CFLAGS="${CFLAGS} -O3"
	export CXXFLAGS="${CXXFLAGS} -O3"

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
}

src_install() {
	if use icarus; then
		newbin "${S}"/icarus/out/icarus icarus
	fi
	newbin "${S}"/higan/out/${PN} ${PN}.bin
	newbin "${FILESDIR}"/${P}-wrapper ${PN}
	make_desktop_entry "${PN}" "${PN}"

	# copy home directory stuff to a global location (matching "${FILESDIR}"/${P}-wrapper)
	insinto /usr/share/${PN}
	doins -r higan/systems/*.sys

	doicon -s 512 higan/data/${PN}.png
	doicon        higan/data/${PN}.svg
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	#elog "optional dependencies:"
	#elog "  dev-games/higan-ananke (extra rom load options)"
	#elog "  games-util/higan-purify (Rom purifier)"

	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
