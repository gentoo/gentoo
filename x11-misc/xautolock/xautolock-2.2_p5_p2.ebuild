# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="An automatic X screen-locker/screen-saver"
HOMEPAGE="http://www.ibiblio.org/pub/Linux/X11/screensavers/"

DEB_REV_MAJ="$(ver_cut 4)"
DEB_REV_MIN="$(ver_cut 6)"
DEB_REVISION="${DEB_REV_MAJ/p}.${DEB_REV_MIN/p}"
SRC_URI="
	${HOMEPAGE}/${P/_p*/}.tgz
	mirror://debian/pool/main/x/${PN}/${PN}_${PV/_p*/}-${DEB_REVISION}.debian.tar.xz
"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~sparc ~x86"

RDEPEND="
	x11-libs/libXScrnSaver
"
DEPEND="
	${RDEPEND}
	app-text/rman
	x11-base/xorg-proto
	x11-misc/imake
"
S=${WORKDIR}/${P/_p*}

src_prepare() {
	eapply "${WORKDIR}"/debian/patches/*.patch
	default
}

src_configure() {
	xmkmf || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install () {
	dobin xautolock
	newman xautolock.man xautolock.1
	dodoc Changelog Readme Todo
}
