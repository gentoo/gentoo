# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="assign particular actions to any key or key combination"
HOMEPAGE="http://wmalms.tripod.com/#XHKEYS"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
"
DEPEND="
	${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto
"

PATCHES=(
	"${FILESDIR}"/${P}-linux_headers.patch
	"${FILESDIR}"/${P}-CC.patch
)

src_install() {
	dobin xhkeys xhkconf
	dodoc README VERSION
}
