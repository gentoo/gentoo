# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="assign particular actions to any key or key combination"
HOMEPAGE="http://wmalms.tripod.com/#XHKEYS"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

PATCHES=(
	"${FILESDIR}"/${P}-linux_headers.patch
	"${FILESDIR}"/${P}-CC.patch
)

src_install() {
	dobin xhkeys xhkconf
	dodoc README VERSION
}
