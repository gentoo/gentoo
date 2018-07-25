# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils

IUSE=""
DESCRIPTION="WMnet is a dock.app network monitor"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz
	mirror://gentoo/${P}-misc.patch.bz2"
HOMEPAGE="https://www.dockapps.net/wmnet"

RDEPEND="x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-misc/imake
	app-text/rman"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc alpha amd64 ppc"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${P}-misc.patch # bug 72818
}

src_compile() {
	xmkmf || die "xmkmf failed."
	emake CDEBUGFLAGS="${CFLAGS}" LDOPTIONS="${LDFLAGS}" || die "emake failed."
}

src_install() {
	dobin wmnet
	newman wmnet.man wmnet.1
	dodoc README Changelog
}
