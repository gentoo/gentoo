# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs versionator

DESCRIPTION="An automatic X screen-locker/screen-saver"
HOMEPAGE="http://www.ibiblio.org/pub/Linux/X11/screensavers/"

DEB_REV_MAJ="$(get_version_component_range 3)"
DEB_REV_MIN="$(get_version_component_range 4)"
DEB_REVISION="${DEB_REV_MAJ/p}.${DEB_REV_MIN/p}"
SRC_URI="
	http://www.ibiblio.org/pub/Linux/X11/screensavers/${P/_p*/}.tgz
	mirror://debian/pool/main/x/${PN}/${PN}_${PV/_p*/}-${DEB_REVISION}.debian.tar.xz
"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="
	x11-libs/libXScrnSaver
"
DEPEND="
	${RDEPEND}
	app-text/rman
	x11-base/xorg-proto
	x11-misc/imake
"
PATCHES=(
	"${WORKDIR}"/debian/patches/10-fix-memory-corruption.patch
	"${WORKDIR}"/debian/patches/11-fix-no-dpms.patch
	"${WORKDIR}"/debian/patches/12-fix-manpage.patch
	"${WORKDIR}"/debian/patches/13-fix-hppa-build.patch
	"${FILESDIR}"/${PN}-2.2_p5_p1-waitpid.patch
)
S=${WORKDIR}/${P/_p*}

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
