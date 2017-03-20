# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="let it snow on your desktop and windows"
HOMEPAGE="http://dropmix.xs4all.nl/rick/Xsnow/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libXpm
"
DEPEND="
	${RDEPEND}
	app-text/rman
	x11-misc/imake
	x11-misc/gccmakedep
	x11-proto/xextproto
	x11-proto/xproto
"

src_compile() {
	xmkmf || die
	make depend || die
	emake \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		LOCAL_LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin xsnow
	rman -f HTML < xsnow._man > xsnow.1-html || die
	newman xsnow._man xsnow.1
	newdoc xsnow.1-html xsnow.1.html
	dodoc README
}
