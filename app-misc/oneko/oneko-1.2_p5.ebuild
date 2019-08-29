# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop toolchain-funcs

DESCRIPTION="A cat, dog and others which chase the mouse or windows around the screen"
HOMEPAGE="http://www.daidouji.com/oneko/"
SRC_URI="
	http://www.daidouji.com/oneko/distfiles/${P/_p*}.sakura.${PV/*_p}.tar.gz
	mirror://gentoo/${P/_p*}-cat.png
	mirror://gentoo/${P/_p*}-dog.png
	mirror://gentoo/${P/_p*}-sakura-nobsd.patch.bz2
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
"
DEPEND="
	${RDEPEND}
	app-text/rman
	x11-base/xorg-proto
	x11-misc/gccmakedep
	x11-misc/imake
"
PATCHES=(
	"${WORKDIR}"/${P/_p*}-sakura-nobsd.patch
	"${FILESDIR}"/${P/_p*}-include.patch
)
S=${WORKDIR}/${P/_*}.sakura.${PV/*_p}

src_configure() {
	xmkmf -a || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CCOPTIONS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	dobin oneko
	newman oneko._man oneko.1x
	dodoc README README-NEW README-SUPP

	newicon "${DISTDIR}/${P/_*}-cat.png" "cat.png"
	newicon "${DISTDIR}/${P/_*}-dog.png" "dog.png"

	make_desktop_entry "oneko" "oneko (cat)" "cat" "Game;Amusement"
	make_desktop_entry "oneko -dog" "oneko (dog)" "dog" "Game;Amusement"
	make_desktop_entry "killall -TERM oneko" "oneko kill" "" "Game;Amusement"
}
