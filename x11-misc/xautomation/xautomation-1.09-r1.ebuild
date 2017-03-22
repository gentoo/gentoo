# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Control X from command line and find things on screen"
HOMEPAGE="http://hoopajoo.net/projects/xautomation.html"
SRC_URI="http://hoopajoo.net/static/projects/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"

RDEPEND="
	>=media-libs/libpng-1.2:0
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXtst
"
DEPEND="
	${RDEPEND}
	x11-proto/inputproto
	x11-proto/xextproto
	x11-proto/xproto
"
