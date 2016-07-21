# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

MY_P=${P/_}

DESCRIPTION="A minimalist, no frills window manager for X"
HOMEPAGE="http://www.6809.org.uk/evilwm/"
SRC_URI="http://www.6809.org.uk/${PN}/${MY_P}.tar.gz"

LICENSE="MIT 9wm"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~sparc64-solaris"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXrandr
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xproto"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -e 's/^#define DEF_FONT.*/#define DEF_FONT "fixed"/' \
		-i evilwm.h || die

	sed -e '/Encoding/d' \
		-i ${PN}.desktop || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" INSTALL_STRIP="" install || die
	dodoc ChangeLog README TODO || die

	echo -e "#!${EPREFIX}/bin/sh\nexec \"${EPREFIX}/usr/bin/${PN}\"" > "${T}"/${PN}
	exeinto /etc/X11/Sessions
	doexe "${T}"/${PN} || die
}
