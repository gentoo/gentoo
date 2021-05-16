# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A simple pager docklet for the WindowMaker window manager"
HOMEPAGE="http://wmpager.sourceforge.net/"
SRC_URI="mirror://sourceforge/wmpager/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXext"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i "s:\(WMPAGER_DEFAULT_INSTALL_DIR \).*:\1\"/usr/share/wmpager\":" \
		src/wmpager.c || die

	#Honour Gentoo CFLAGS and LDFLAGS, see bug #337604
	sed -i -e "s/-g/${CFLAGS}/" \
		-e "s/\${LIBS}/\${LIBS} \${LDFLAGS}/" \
		src/Makefile || die
}

src_install() {
	emake INSTALLDIR="${ED}/usr" install
	rm -rf "${ED}"/usr/man || die
	doman man/man1/*.1x
	dodoc README
}
