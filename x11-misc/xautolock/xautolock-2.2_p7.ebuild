# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="An automatic X screen-locker/screen-saver"
HOMEPAGE="http://www.ibiblio.org/pub/Linux/X11/screensavers/"

DEB_REVISION="$(ver_cut 4)"
SRC_URI="
	http://www.ibiblio.org/pub/Linux/X11/screensavers/${P/_p*/}.tgz
	mirror://debian/pool/main/x/${PN}/${PN}_${PV/_p*/}-${DEB_REVISION}.debian.tar.xz
"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 sparc x86"

RDEPEND="
	x11-libs/libXScrnSaver
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	app-text/rman
	sys-devel/gcc
	>=x11-misc/imake-1.0.8-r1
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.2_p5_p1-waitpid.patch
)
S=${WORKDIR}/${P/_p*}

src_prepare() {
	mv "${WORKDIR}"/debian/patches/14-do-not-use-union-wait-type.patch{,.skip} || die
	eapply "${WORKDIR}"/debian/patches/*.patch
	default
}

src_configure() {
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}" xmkmf || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	dobin xautolock
	newman xautolock.man xautolock.1
	dodoc Changelog Readme Todo
}
