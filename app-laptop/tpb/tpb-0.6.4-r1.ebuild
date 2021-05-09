# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit linux-info epatch

DESCRIPTION="IBM ThinkPad buttons utility"
HOMEPAGE="https://savannah.nongnu.org/projects/tpb/"
SRC_URI="https://savannah.nongnu.org/download/tpb/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 -ppc x86"
IUSE="nls xosd"

RDEPEND="x11-libs/libXt
	x11-libs/libXext
	xosd? ( >=x11-libs/xosd-2.2.0 )"
DEPEND="${RDEPEND}"

CONFIG_CHECK="~NVRAM"
ERROR_NVRAM="${P} requires /dev/nvram support (CONFIG_NVRAM)"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-configure-fix.diff
	epatch "${FILESDIR}"/${P}-nvram.patch
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable xosd)
}

src_install() {
	default
	dodoc doc/{callback_example.sh,nvram.txt,tpbrc}
}
