# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Commandline tool to take screenshots of the desktop"
HOMEPAGE="https://github.com/naelstrof/maim"
SRC_URI="https://github.com/naelstrof/maim/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=( "${FILESDIR}/maim-3.4.47-no-gengetopt.patch" )

DEPEND="
	media-libs/imlib2[X]
	x11-libs/libX11
	x11-libs/libXrandr
	x11-libs/libXfixes"
RDEPEND="
	${DEPEND}
	x11-misc/slop"
