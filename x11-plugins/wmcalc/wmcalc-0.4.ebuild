# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmcalc/wmcalc-0.4.ebuild,v 1.15 2012/02/15 09:44:32 voyageur Exp $

inherit multilib toolchain-funcs

DESCRIPTION="A WindowMaker DockApp calculator"
HOMEPAGE="http://dockapps.windowmaker.org/file.php/id/130"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e "s:gcc:$(tc-getCC):g" \
		-e "s:-O2:${CFLAGS}:g" -i Makefile

	#Honour Gentoo LDFLAGS, see bug #337434
	sed -e "s:-o \${TARGET}:\$(LDFLAGS) -o \${TARGET}:" -i Makefile
}

src_compile() {
	emake INCLUDES="-I/usr/include/X11" \
		LIBINC="-L/usr/$(get_libdir)" \
		|| die "emake failed."
}

src_install() {
	dodir /etc /usr/bin

	emake DESTDIR="${D}" PREFIX="/usr" install \
		|| die "emake install failed."

	dodoc README
	newman "${FILESDIR}"/wmcalc.man wmcalc.1
}
