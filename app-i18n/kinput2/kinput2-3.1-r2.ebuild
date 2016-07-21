# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
inherit eutils

MY_P="${PN}-v${PV}"
DESCRIPTION="A Japanese input server which supports the XIM protocol"
HOMEPAGE="http://www.nec.co.jp/canna/"
SRC_URI="ftp://ftp.sra.co.jp/pub/x11/${PN}/${MY_P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"
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

src_prepare() {
	epatch "${FILESDIR}/${P}-r1-gentoo.diff"

	if use freewnn; then
		sed -i -e '/\/\* #define UseWnn/s:^:#define UseWnn\n:' Kinput2.conf || die
	else
		sed -i -e '/\/\* #define UseCanna/s:^:#define UseCanna\n:' Kinput2.conf || die
	fi
}

src_configure() {
	xmkmf -a || die
}

src_compile() {
	emake \
		XAPPLOADDIR="${EPREFIX}/usr/share/X11/app-defaults/" \
		CDEBUGFLAGS="${CFLAGS}" \
		LOCAL_LDFLAGS="${LDFLAGS}" \
		|| die
}

src_install() {
	emake XAPPLOADDIR="/usr/share/X11/app-defaults/" DESTDIR="${D}" install || die
	rm -rf "${ED}/usr/lib/X11" || die

	local server
	if use freewnn; then
		server="wnn"
	else
		server="canna"
	fi

	insinto /etc/X11/xinit/xinput.d
	sed \
		-e "s:@EPREFIX@:${EPREFIX}:g" \
		-e "s:@SERVER@:${server}:g" \
		"${FILESDIR}/xinput-kinput2" > "${T}/kinput2.conf" || die
	doins "${T}/kinput2.conf" || die

	dodoc README NEWS doc/* || die
	newman cmd/${PN}.man ${PN}.1 || die
}
