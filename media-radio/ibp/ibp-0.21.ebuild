# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-radio/ibp/ibp-0.21.ebuild,v 1.5 2012/11/12 19:14:37 tomjbe Exp $

EAPI="4"
inherit eutils toolchain-funcs

DESCRIPTION="Shows currently transmitting beacons of the International Beacon Project (IBP)"
HOMEPAGE="http://wwwhome.cs.utwente.nl/~ptdeboer/ham/${PN}.html"
SRC_URI="http://wwwhome.cs.utwente.nl/~ptdeboer/ham/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="X"

RDEPEND="sys-libs/ncurses
	X? ( x11-libs/libX11  )"
DEPEND="${RDEPEND}
	X? ( x11-misc/imake )"

src_prepare() {
	# respect CFLAGS if built without USE=X
	sed -i -e "s/= -D/+= -D/" Makefile || die
}

src_configure() {
	if use X ;then
		xmkmf || die
	fi
}

src_compile() {
	if use X ; then
		emake \
			CC="$(tc-getCC)" \
			LOCAL_LDFLAGS="${LDFLAGS}" \
			CDEBUGFLAGS="${CFLAGS}"
	else
		emake CC="$(tc-getCC)"
	fi
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
