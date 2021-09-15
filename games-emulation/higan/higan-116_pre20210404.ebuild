# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT=9a625c545ca89b094d5c1da40bbfa5d07156a4aa

inherit desktop toolchain-funcs xdg

DESCRIPTION="Multi-system emulator focused on accuracy, preservation, and configurability"
HOMEPAGE="https://github.com/higan-emu/higan"
SRC_URI="https://github.com/higan-emu/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa ao +gtk openal +opengl oss +pulseaudio +sdl udev xv"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	alsa? ( media-libs/alsa-lib )
	ao? ( media-libs/libao )
	openal? ( media-libs/openal )
	opengl? ( virtual/opengl )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( media-libs/libsdl2[joystick] )
	udev? ( virtual/udev )
	xv? ( x11-libs/libXv )
	gtk? (
		x11-libs/cairo
		x11-libs/gtk+:3
		x11-libs/gtksourceview:3.0
	)
	!gtk? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# insane build system, reinvents every built-in rule
	"${FILESDIR}"/${P}-makefile.patch
)

src_compile() {
	local makeopts=(
		platform=linux
		compiler="$(tc-getCXX)"
		hiro="$(usex gtk gtk3 qt5)"
	)

	local drivers=(
		video.xshm
		input.xlib
		$(usex alsa audio.alsa "")
		$(usex ao audio.ao "")
		$(usex openal audio.openal "")
		$(usex opengl "video.glx video.glx2" "")
		$(usex oss audio.oss "")
		$(usex pulseaudio "audio.pulseaudio audio.pulseaudiosimple" "")
		$(usex sdl input.sdl "")
		$(usex udev input.udev "")
		$(usex xv video.xvideo "")
	)

	local coreopts=(
		cores="cv fc gb gba md ms msx ngp pce sfc sg ws"
		ruby="${drivers[*]}"
		build=performance
		local=false
	)

	# Make higan
	emake "${makeopts[@]}" "${coreopts[@]}" -C higan-ui

	# Make icarus
	emake "${makeopts[@]}" -C icarus
}

src_install() {
	# Install higan
	dobin higan-ui/out/higan

	insinto /usr/share/${P}
	doins -r higan/System

	domenu higan-ui/resource/higan.desktop
	doicon -s 256 higan-ui/resource/higan.png

	doins -r extras

	# Install icarus
	dobin icarus/out/icarus

	domenu icarus/resource/icarus.desktop
	doicon -s scalable icarus/resource/icarus.svg

	insinto /usr/share/${P}/Database
	doins -r icarus/Database
	insinto /usr/share/${P}/Firmware
	doins -r icarus/Firmware
}
