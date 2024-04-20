# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop toolchain-funcs

DESCRIPTION="A cat, dog and others which chase the mouse or windows around the screen"
HOMEPAGE="http://www.daidouji.com/oneko/"
SRC_URI="
	mirror://debian/pool/main/o/${PN}/${PN}_$(ver_cut 1-2).sakura.$(ver_cut 4)-$(ver_cut 6).debian.tar.xz
	mirror://debian/pool/main/o/${PN}/${PN}_$(ver_cut 1-2).sakura.$(ver_cut 4).orig.tar.gz
	mirror://gentoo/${P/_p*}-cat.png
	mirror://gentoo/${P/_p*}-dog.png
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	app-text/rman
	sys-devel/gcc
	x11-misc/gccmakedep
	>=x11-misc/imake-1.0.8-r1
"
PATCHES=(
	"${FILESDIR}"/${P/_p*}-include.patch
)
S=${WORKDIR}/${PN}-$(ver_cut 1-2).sakura.$(ver_cut 4).orig

src_prepare() {
	for patch in $(< "${WORKDIR}"/debian/patches/series); do
		eapply "${WORKDIR}"/debian/patches/${patch}
	done

	default
}

src_configure() {
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}" xmkmf -a || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	dobin oneko
	newman oneko._man oneko.1x
	dodoc README README-NEW README-SUPP

	newicon "${DISTDIR}"/${P/_*}-cat.png cat.png
	newicon "${DISTDIR}"/${P/_*}-dog.png dog.png

	make_desktop_entry "oneko" "oneko (cat)" "cat" "Game;Amusement"
	make_desktop_entry "oneko -dog" "oneko (dog)" "dog" "Game;Amusement"
	make_desktop_entry "killall -TERM oneko" "oneko kill" "" "Game;Amusement"
}
