# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils toolchain-funcs

MY_P=${P}tp

DESCRIPTION="Turns your root window into an aquarium"
HOMEPAGE="http://www.ibiblio.org/pub/Linux/X11/demos/"
SRC_URI="http://www.ibiblio.org/pub/Linux/X11/demos/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-linux"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-misc/imake"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-implicits.patch
}

src_compile() {
	xmkmf || die
	emake CDEBUGFLAGS="${CFLAGS}" CC="$(tc-getCC)" \
		EXTRA_LDOPTIONS="${LDFLAGS}" ${PN} || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README README.Linux README.TrueColor README.Why.2.1tp || die
}
