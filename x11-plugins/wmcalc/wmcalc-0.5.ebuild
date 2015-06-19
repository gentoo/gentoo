# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmcalc/wmcalc-0.5.ebuild,v 1.1 2015/01/13 12:41:19 voyageur Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="A WindowMaker DockApp calculator"
HOMEPAGE="http://windowmaker.org/dockapps/?name=wmcalc"
# Grab from http://windowmaker.org/dockapps/?download=${P}.tar.gz
SRC_URI="http://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto"

S=${WORKDIR}/dockapps

src_prepare() {
	sed -e "/\$(INSTALL_DIR)/s/\/man1//" -i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install

	dodoc README
}
