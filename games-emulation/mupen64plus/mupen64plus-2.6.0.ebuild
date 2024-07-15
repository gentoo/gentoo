# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A fork of Mupen64 Nintendo 64 emulator, meta-package"
HOMEPAGE="https://www.mupen64plus.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+audio-sdl +input-sdl +rsp-hle +ui-console +ui-m64py +video-glide64mk2 +video-rice"

RDEPEND="
	>=games-emulation/mupen64plus-core-${PV}
	audio-sdl? ( >=games-emulation/mupen64plus-audio-sdl-${PV} )
	input-sdl? ( >=games-emulation/mupen64plus-input-sdl-${PV} )
	rsp-hle? ( >=games-emulation/mupen64plus-rsp-hle-${PV} )
	ui-console? ( >=games-emulation/mupen64plus-ui-console-${PV} )
	ui-m64py? ( >=games-emulation/m64py-0.2.3-r1 )
	video-glide64mk2? ( >=games-emulation/mupen64plus-video-glide64mk2-${PV} )
	video-rice? ( >=games-emulation/mupen64plus-video-rice-${PV} )
"
