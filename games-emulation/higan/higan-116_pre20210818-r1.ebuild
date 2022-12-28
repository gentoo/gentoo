# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

HIGAN_COMMIT="9bf1b3314b2bcc73cbc11d344b369c31562aff10"

DESCRIPTION="Multi-system emulator focused on accuracy, preservation, and configurability"
HOMEPAGE="https://github.com/higan-emu/higan"
SRC_URI="https://github.com/higan-emu/higan/archive/${HIGAN_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${HIGAN_COMMIT}"

LICENSE="GPL-3+ ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa ao +gtk openal +opengl oss +pulseaudio +sdl udev xv"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	alsa? ( media-libs/alsa-lib )
	ao? ( media-libs/libao )
	openal? ( media-libs/openal )
	opengl? ( virtual/opengl )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( media-libs/libsdl2[joystick] )
	udev? ( virtual/libudev:= )
	xv? ( x11-libs/libXv )
	gtk? (
		dev-libs/glib:2
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3[X]
		x11-libs/gtksourceview:3.0=
		x11-libs/pango
	)
	!gtk? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# insane build system, reinvents every built-in rule
	"${FILESDIR}"/${PN}-116_pre20210404-makefile.patch
	"${FILESDIR}"/${PN}-116_pre20210818-paths.patch
)

src_prepare() {
	default

	use !prefix || sed -i "s|/usr/share|${EPREFIX}&|" nall/path.hpp || die
}

src_compile() {
	local makeopts=(
		platform=linux
		compiler="$(tc-getCXX)"
		hiro=$(usex gtk gtk3 qt5)
	)

	local drivers=(
		video.xshm
		input.xlib
		$(usev alsa audio.alsa)
		$(usev ao audio.ao)
		$(usev openal audio.openal)
		$(usev opengl "video.glx video.glx2")
		$(usev oss audio.oss)
		$(usev pulseaudio "audio.pulseaudio audio.pulseaudiosimple")
		$(usev sdl input.sdl)
		$(usev udev input.udev)
		$(usev xv video.xvideo)
	)

	local coreopts=(
		cores="cv fc gb gba md ms msx ngp pce sfc sg ws"
		ruby="${drivers[*]}"
		build=performance
		local=false
	)

	emake "${makeopts[@]}" "${coreopts[@]}" -C higan-ui

	emake "${makeopts[@]}" -C icarus
}

src_install() {
	dobin higan-ui/out/higan
	domenu higan-ui/resource/higan.desktop
	doicon higan-ui/resource/higan.png

	dobin icarus/out/icarus
	domenu icarus/resource/icarus.desktop
	doicon icarus/resource/icarus.svg

	insinto /usr/share/higan
	doins -r icarus/{Database,Firmware}
	use opengl && doins -r extras/Shaders

	insinto /usr/share/higan/Templates
	doins -r higan/System/.
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} ]] &&
		ver_test ${REPLACING_VERSIONS} -lt 116_pre20210818; then
		elog "On new installs, higan now uses ~/.local/share/higan/Systems/ rather than"
		elog "~/higan/, and reads Templates from ${EROOT}/usr/share/higan/ on Gentoo."
		elog "Will need to edit/delete ~/.config/higan/paths.bml for this to take effect."
		elog
		elog "Additionally, system's shaders will be used if ~/.config/higan/Shaders"
		elog "does not exist, and icarus now uses the system's Database+Firmware files."
	fi
}
