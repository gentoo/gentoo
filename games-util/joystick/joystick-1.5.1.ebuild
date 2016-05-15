# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils toolchain-funcs

MY_P="linuxconsoletools-${PV}"
DESCRIPTION="joystick testing utilities"
HOMEPAGE="http://sourceforge.net/projects/linuxconsole/ http://atrey.karlin.mff.cuni.cz/~vojtech/input/"
SRC_URI="mirror://sourceforge/linuxconsole/files/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="sdl udev"

DEPEND="sdl? ( media-libs/libsdl:0[video] )
	!<x11-libs/tslib-1.0-r2"
RDEPEND="${DEPEND}
	udev? ( virtual/udev )"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.1-build.patch
	"${FILESDIR}"/${PN}-1.4.8-udev.patch
)

src_prepare() {
	default

	export PREFIX=/usr
	tc-export CC PKG_CONFIG
	export USE_SDL=$(usex sdl)
}

src_install() {
	default
	if use !udev ; then
		rm "${D}"/usr/bin/jscal-{re,}store || die
	fi
}
