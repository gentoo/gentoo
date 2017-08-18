# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Command line tool to take screenshots of the desktop"
HOMEPAGE="https://github.com/naelstrof/maim"
SRC_URI="https://github.com/naelstrof/maim/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	virtual/jpeg:*
	media-libs/libpng:0
	x11-libs/libX11
	x11-libs/libXrandr
	x11-libs/libXfixes
	>=x11-misc/slop-7.3.48"
RDEPEND="${DEPEND}"
