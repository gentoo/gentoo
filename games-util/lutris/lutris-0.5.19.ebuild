# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="sqlite,threads(+)"

inherit meson python-single-r1 optfeature virtualx xdg

DESCRIPTION="An open source gaming platform for GNU/Linux"
HOMEPAGE="https://lutris.net/"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/lutris/lutris.git"
	inherit git-r3
else
	SRC_URI="https://github.com/lutris/lutris/archive/refs/tags/v${PV/_/-}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}"/${P/_/-}
	if [[ ${PV} != *_beta* ]] ; then
		KEYWORDS="~amd64 ~x86"
	fi
fi

LICENSE="GPL-3+ CC0-1.0"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-arch/cabextract
	|| (
		>=app-arch/7zip-24.09[symlink(+)]
		app-arch/p7zip
	)
	app-arch/unzip
	$(python_gen_cond_dep '
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/evdev[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
		dev-python/pypresence[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/protobuf[${PYTHON_USEDEP}]
		dev-python/moddb[${PYTHON_USEDEP}]
	')
	media-sound/fluid-soundfont
	|| (
		net-libs/webkit-gtk:4[introspection]
		net-libs/webkit-gtk:4.1[introspection]
	)
	sys-apps/pciutils
	sys-apps/xdg-desktop-portal
	x11-apps/mesa-progs
	x11-apps/xgamma
	x11-apps/xrandr
	x11-libs/gtk+:3[introspection]
	x11-libs/gdk-pixbuf[jpeg]
"

BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
		')
	)
"

DOCS=( AUTHORS README.rst docs/installers.rst docs/steam.rst )

EPYTEST_IGNORE=(
	# Requires a Nvidia GPU and driver
	tests/util/graphics/test_drivers.py
)

src_test() {
	meson_src_test
	virtx epytest
}

src_install() {
	meson_src_install
	python_optimize
	python_fix_shebang "${ED}/usr/" #740048
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "playing various games through Valve's Steam launcher (available in Steam overlay)" games-util/steam-launcher
	optfeature "playing games through Valve's micro-compositor" gui-wm/gamescope
	optfeature "playing games inside a nested X server" x11-base/xorg-server[xephyr]
	optfeature "installing and playing games from Flathub" sys-apps/flatpak
	optfeature "playing Microsoft Windows games" virtual/wine
	optfeature "playing DirectX based games by translating DirectX to Vulkan" "media-libs/vulkan-loader dev-util/vulkan-tools app-emulation/dxvk virtual/wine"
	optfeature "playing Vulkan based games (plus ICD for your hardware)" "media-libs/vulkan-loader dev-util/vulkan-tools"
	optfeature "a Vulkan and OpenGL overlay for monitoring system performance (available in GURU overlay)" games-util/mangohud
	elog

	optfeature_header "${PN} supports various emulators and compatibility layers. \n${PN} can download and install these by itself, but also supports using system-wide installed versions"
	optfeature "playing games through x86 PC emulator" app-emulation/86Box
	# TODO: Package Adventure Game Studio runner
	optfeature "playing Atari 800 games through an emulator" games-emulation/atari800
	# TODO: Package Basilisk II Mac emulator
	# TODO: Package Wii U emulator
	optfeature "playing Nintendo 3DS games through an emulator (available in GURU overlay)" games-emulation/citra
	# TODO: Package ColecoVision/Coleco Adam emulator
	optfeature "playing Nintendo DS games through an emulator" games-emulation/desmume
	optfeature "playing Sega Genesis games through an emulator" games-emulation/dgen-sdl
	optfeature "playing GameCube and Wii games through an emulator" games-emulation/dolphin
	optfeature "playing DOS games through an emulator" games-emulation/dosbox
	optfeature "playing RPG Maker 2000/2003 games (available in GURU overlay)" games-engines/easyrpg-player
	optfeature "playing Z-code based text games" games-engines/frotz
	optfeature "playing Amiga games through an emulator" app-emulation/fs-uae
	optfeature "playing Atari ST games through an emulator" games-emulation/hatari
	# TODO: Package Intellivision emulator
	optfeature "playing games through various emulators" games-emulation/libretro-info
	optfeature "playing Arcade games through an emulator" games-emulation/advancemame
	optfeature "playing games through various emulators" games-emulation/mednafen
	optfeature "playing Nintendo DS games through an emulator" games-emulation/melonds
	# TODO: Package mGBA
	# TODO: Package MicroM8 Apple II emulator
	# TODO: Package Mini vMac emulator
	optfeature "playing Nintendo 64 games through an emulator" games-emulation/mupen64plus
	# TODO: Package O2Em emulator
	# TODO: Package Sega Master System emulator
	optfeature "playing IBM PC games through an emulator" app-emulation/pcem
	optfeature "playing Sony PlayStation 2 games through an emulator" games-emulation/pcsx2
	optfeature "playing various fantasy games" dev-lang/pico8
	optfeature "playing Sony PlayStation Portable games through an emulator" games-emulation/ppsspp
	# TODO: Package SEGA Dreamcast emulator redream
	# TODO: Package SEGA Dreamcast emulator reicast
	# TODO: Package Rosalie's Mupen GUI
	optfeature "playing Sony PlayStation 3 games through an emulator (available in GURU overlay)" games-emulation/rpcs3
	optfeature "playing Adobe Flash Player games through an emulator" app-emulation/ruffle
	# TODO: Package Nintendo Switch emulator
	optfeature "playing Lucasarts adventure games" games-engines/scummvm
	# TODO: Package PowerMacintosh emulator
	optfeature "playing Super Nintendo (SNES) games through an emulator" games-emulation/snes9x
	# TODO: Package Sinclair ZX Spectrum emulator
	optfeature "playing Atari 2600 VCS games through an emulator" games-emulation/stella
	# TODO: Package TIC-80 tiny computer
	optfeature "playing Commodore games through an emulator" app-emulation/vice
	# TODO: Package Atari Jaguar emulator
	# TODO: Package Vita3K PS Vita emulator
	# TODO: Package runner for HTML5 web games
	# TODO: Package Xbox emulator
	optfeature "playing Nintendo Switch games through an emulator (available in GURU overlay)" games-emulation/yuzu
	optfeature "playing DOOM games" games-fps/gzdoom

	# Quote README.rst
	elog
	elog "Lutris installations are fully automated through scripts, which can"
	elog "be written in either JSON or YAML. The scripting syntax is described"
	elog "in ${EROOT}/usr/share/doc/${PF}/installers.rst.bz2, and is also"
	elog "available online at lutris.net."
}
