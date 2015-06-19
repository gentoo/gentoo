# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xkeycaps/xkeycaps-2.47-r1.ebuild,v 1.7 2012/12/23 20:23:24 ulm Exp $

inherit eutils toolchain-funcs

DESCRIPTION="GUI frontend to xmodmap"
HOMEPAGE="http://packages.qa.debian.org/x/xkeycaps.html"
SRC_URI="mirror://debian/pool/main/x/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="x11-misc/xbitmaps
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXaw
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-misc/imake
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-Imakefile.patch \
		"${FILESDIR}"/${P}-man.patch
}

src_compile() {
	xmkmf || die
	sed -i -e "s,all:: xkeycaps.\$(MANSUFFIX).html,all:: ,g" \
		Makefile || die
	emake EXTRA_LDOPTIONS="${LDFLAGS}" CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" || die
}

src_install () {
	emake DESTDIR="${D}" install || die
	newman ${PN}.man ${PN}.1 || die
	dodoc README *.txt || die
}
