# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT="0a672473f583c6e4df3b1714d4af79653910811e"

inherit autotools

DESCRIPTION="Utility to get/set registers and controlling backlight on radeon based GPUs"
HOMEPAGE="https://cgit.freedesktop.org/~airlied/radeontool/"
SRC_URI="https://dev.gentoo.org/~conikost/distfiles/${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="x11-libs/libpciaccess"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}
