# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/mupen64plus/mupen64plus-2.0.ebuild,v 1.1 2013/12/15 13:36:42 mgorny Exp $

EAPI=5

DESCRIPTION="A fork of Mupen64 Nintendo 64 emulator, meta-package"
HOMEPAGE="http://code.google.com/p/mupen64plus/"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+audio-sdl +input-sdl +rsp-hle +ui-console +ui-m64py +video-glide64mk2 +video-rice"

RDEPEND="games-emulation/mupen64plus-core
	audio-sdl? ( games-emulation/mupen64plus-audio-sdl )
	input-sdl? ( games-emulation/mupen64plus-input-sdl )
	rsp-hle? ( games-emulation/mupen64plus-rsp-hle )
	ui-console? ( games-emulation/mupen64plus-ui-console )
	ui-m64py? ( games-emulation/m64py )
	video-glide64mk2? ( games-emulation/mupen64plus-video-glide64mk2 )
	video-rice? ( games-emulation/mupen64plus-video-rice )"
