# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A fork of Mupen64 Nintendo 64 emulator, meta-package"
HOMEPAGE="http://www.mupen64plus.org/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+audio-sdl +input-sdl +rsp-hle +ui-console +ui-m64py +video-glide64mk2 +video-rice"

RDEPEND=">=games-emulation/mupen64plus-core-2.5
	audio-sdl? ( >=games-emulation/mupen64plus-audio-sdl-2.5 )
	input-sdl? ( >=games-emulation/mupen64plus-input-sdl-2.5 )
	rsp-hle? ( >=games-emulation/mupen64plus-rsp-hle-2.5 )
	ui-console? ( >=games-emulation/mupen64plus-ui-console-2.5 )
	ui-m64py? ( >=games-emulation/m64py-0.2.3-r1 )
	video-glide64mk2? ( >=games-emulation/mupen64plus-video-glide64mk2-2.5 )
	video-rice? ( >=games-emulation/mupen64plus-video-rice-2.5 )"
