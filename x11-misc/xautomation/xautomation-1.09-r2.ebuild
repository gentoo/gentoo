# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Control X from command line and find things on screen"
HOMEPAGE="https://hoopajoo.net/projects/xautomation.html"
SRC_URI="https://hoopajoo.net/static/projects/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc x86"

RDEPEND="
	media-libs/libpng:=
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXtst"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
