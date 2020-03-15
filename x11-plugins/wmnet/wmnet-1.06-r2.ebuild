# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="WMnet is a dock.app network monitor"
HOMEPAGE="https://www.dockapps.net/wmnet"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz
	mirror://gentoo/${P}-misc.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-misc/imake
	app-text/rman"

PATCHES=( "${WORKDIR}"/${P}-misc.patch )

src_compile() {
	xmkmf || die "xmkmf failed."
	emake CDEBUGFLAGS="${CFLAGS}" LDOPTIONS="${LDFLAGS}"
}

src_install() {
	dobin wmnet
	newman wmnet.man wmnet.1
	dodoc README Changelog
}
