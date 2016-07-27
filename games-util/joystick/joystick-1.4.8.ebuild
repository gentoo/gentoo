# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

MY_P="linuxconsoletools-${PV}"
DESCRIPTION="joystick testing utilities"
HOMEPAGE="https://sourceforge.net/projects/linuxconsole/ http://atrey.karlin.mff.cuni.cz/~vojtech/input/"
SRC_URI="mirror://sourceforge/linuxconsole/files/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~ppc x86"
IUSE="sdl"

DEPEND="sdl? ( media-libs/libsdl:0[video] )
	!<x11-libs/tslib-1.0-r2"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	export PREFIX=/usr
	tc-export CC PKG_CONFIG
	export USE_SDL=$(usex sdl)
}
