# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/lwm/lwm-1.2.3.ebuild,v 1.1 2013/07/22 10:51:20 jer Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="The ultimate lightweight window manager"
SRC_URI="http://www.jfc.org.uk/files/lwm/${P}.tar.gz"
HOMEPAGE="http://www.jfc.org.uk/software/lwm.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
"
DEPEND="
	${RDEPEND}
	x11-misc/imake
	x11-proto/xextproto
	x11-proto/xproto
"

src_prepare() {
	sed -i -e "s/(SMLIB)/& -lICE/g" Imakefile || die #370127
	xmkmf || die
}

src_compile() {
	emake \
		EXTRA_LDOPTIONS="${CFLAGS} ${LDFLAGS}" \
		CFLAGS="${CFLAGS}" \
		CC="$(tc-getCC)" \
		lwm || die
}

src_install() {
	dobin lwm

	newman lwm.man lwm.1
	dodoc AUTHORS BUGS ChangeLog
}
