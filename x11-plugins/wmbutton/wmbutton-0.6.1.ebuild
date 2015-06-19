# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmbutton/wmbutton-0.6.1.ebuild,v 1.8 2014/08/10 20:05:11 slyfox Exp $

inherit eutils toolchain-funcs

DESCRIPTION="a dockapp application that displays nine configurable buttons"
HOMEPAGE="http://www.freshports.org/x11/wmbutton"
SRC_URI="ftp://ftp.freebsd.org/pub/FreeBSD/ports/distfiles/${P}.tar.gz
	branding? ( mirror://gentoo/${PN}-buttons.xpm )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="branding"

RDEPEND="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto
	dev-util/ctags"

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"
	epatch "${FILESDIR}"/${P}-Makefile.patch
	use branding && cp "${DISTDIR}"/${PN}-buttons.xpm buttons.xpm
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed."
}

src_install() {
	dobin ${PN}
	dodoc README
	use branding && dodoc "${FILESDIR}"/sample.wmbutton
	use branding || newdoc .wmbutton sample.wmbutton
}
