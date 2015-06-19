# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/kinput2/kinput2-3.1-r1.ebuild,v 1.18 2012/11/25 22:40:59 naota Exp $

inherit eutils

MY_P="${PN}-v${PV}"
DESCRIPTION="A Japanese input server which supports the XIM protocol"
HOMEPAGE="http://www.nec.co.jp/canna/"
SRC_URI="ftp://ftp.sra.co.jp/pub/x11/${PN}/${MY_P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64 ppc64"
IUSE="freewnn"

RDEPEND="freewnn? ( >=app-i18n/freewnn-1.1.1_alpha19 )
	!freewnn? ( >=app-i18n/canna-3.5_beta2-r1 )
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXmu
	x11-libs/libXp
	x11-libs/libXt"

DEPEND="${RDEPEND}
	x11-misc/gccmakedep
	x11-misc/imake
	app-text/rman"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	local mysed=""

	unpack ${A}
	epatch "${FILESDIR}/${PF}-gentoo.diff"

	if use freewnn; then
		sed -i -e '/\/\* #define UseWnn/s:^:#define UseWnn\n:' "${S}/Kinput2.conf"
	else
		sed -i -e '/\/\* #define UseCanna/s:^:#define UseCanna\n:' "${S}/Kinput2.conf"
	fi
}

src_compile() {
	xmkmf -a || die
	emake \
		XAPPLOADDIR="/usr/share/X11/app-defaults/" \
		CDEBUGFLAGS="${CFLAGS}" \
		LOCAL_LDFLAGS="${LDFLAGS}" \
		|| die
}

src_install() {
	emake XAPPLOADDIR="/usr/share/X11/app-defaults/" DESTDIR="${D}" install || die
	rm -rf "${D}/usr/lib/X11"

	dodoc README NEWS doc/*
	newman cmd/${PN}.man ${PN}.1
}
