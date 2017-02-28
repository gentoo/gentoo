# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A tiny monitor calibration loader for X.org"
HOMEPAGE="https://github.com/OpenICC/xcalib"
COMMIT="95c932996cfc9f792dea4a6c49fec3c1ed2267ac"
SRC_URI="${HOMEPAGE}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXrandr
	x11-libs/libXxf86vm
"
DEPEND="${RDEPEND}
	x11-libs/libXext
	x11-proto/xf86vidmodeproto
"

S="${WORKDIR}/${PN}-${COMMIT}"
