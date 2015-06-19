# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/unclutter/unclutter-8-r2.ebuild,v 1.8 2014/08/10 20:04:20 slyfox Exp $

EAPI=2

inherit toolchain-funcs

DESCRIPTION="Hides mouse pointer while not in use"
HOMEPAGE="http://www.ibiblio.org/pub/X11/contrib/utilities/unclutter-8.README"
SRC_URI="ftp://ftp.x.org/contrib/utilities/${P}.tar.Z"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="alpha amd64 hppa ~mips ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xproto"

S=${WORKDIR}/${PN}

src_prepare() {
	sed -i -e "/stdio/ a #include <stdlib.h>" unclutter.c || die #implictits
}

src_compile() {
	emake CDEBUGFLAGS="${CFLAGS}" CC="$(tc-getCC)" \
		LDOPTIONS="${LDFLAGS}" || die
}

src_install () {
	dobin unclutter || die
	newman unclutter.man unclutter.1x || die
	dodoc README || die
}
