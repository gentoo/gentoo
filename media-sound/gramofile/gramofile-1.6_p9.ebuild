# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Transfer sound from gramophone records to CD"
HOMEPAGE="http://www.opensourcepartners.nl/~costar/gramofile"
SRC_URI="
	mirror://debian/pool/main/g/${PN}/${PN}_${PV/_p*}.orig.tar.gz
	mirror://debian/pool/main/g/${PN}/${PN}_${PV/_p*}-${PV/*_p}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="
	sys-libs/ncurses:=
	sci-libs/fftw:2.1"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${P/_p*}"

PATCHES=(
	"${WORKDIR}"/${PN}_${PV/_p*}-${PV/*_p}.diff
	"${S}"/debian/patches
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-strlen_and_exit.patch
)

src_configure() {
	tc-export CC PKG_CONFIG
}

src_install() {
	dobin gramofile

	exeinto /usr/$(get_libdir)/gramofile
	doexe bplay_gramo brec_gramo

	dodoc ChangeLog README TODO *.txt
	newdoc debian/changelog ChangeLog.debian
}
