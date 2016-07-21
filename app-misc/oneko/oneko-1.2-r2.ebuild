# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="A cat, dog and others which chase the mouse or windows around the screen"
HOMEPAGE="http://www.daidouji.com/oneko/"
SRC_URI="http://www.daidouji.com/oneko/distfiles/${P}.sakura.5.tar.gz
	mirror://gentoo/${P}-cat.png
	mirror://gentoo/${P}-dog.png
	mirror://gentoo/${P}-sakura-nobsd.patch.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
"
DEPEND="
	${RDEPEND}
	x11-misc/gccmakedep
	x11-misc/imake
	app-text/rman
	x11-proto/xextproto
"

S=${WORKDIR}/oneko-${PV}.sakura.5

src_prepare() {
	epatch \
		"${WORKDIR}"/${P}-sakura-nobsd.patch \
		"${FILESDIR}"/${P}-include.patch
}

src_configure() {
	xmkmf -a || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CCOPTIONS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		|| die
}

src_install() {
	dobin oneko
	newman oneko._man oneko.1x
	dodoc README README-NEW README-SUPP
	newicon "${DISTDIR}/${P}-cat.png" "cat.png"
	newicon "${DISTDIR}/${P}-dog.png" "dog.png"
	make_desktop_entry "oneko" "oneko (cat)" "cat" "Game;Amusement"
	make_desktop_entry "oneko -dog" "oneko (dog)" "dog" "Game;Amusement"
	make_desktop_entry "killall -TERM oneko" "oneko kill" "" "Game;Amusement"
}

pkg_postinst() {
	elog "To kill oneko, type the following in a terminal:"
	elog ""
	elog "killall oneko"
	elog ""
	elog "If your mouse cursor changes to the default black cross"
	elog "after running ${PN}, you should emerge x11-apps/xsetroot"
	elog "and run:"
	elog ""
	elog "xsetroot -cursor_name left_ptr"
	elog ""
}
