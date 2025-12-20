# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="embed secure hashes (SHA1) and digital signatures (GNU Privacy Guard) into files"
HOMEPAGE="https://packages.debian.org/jessie/bsign"
SRC_URI="mirror://debian/pool/main/b/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~x86"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}"/${P}-non-gnu.patch # for Darwin, BSD, Solaris, etc.
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-scripts.patch
)

src_prepare() {
	default
	mv configure.in configure.ac
	eautoreconf
}

src_configure() {
	use static-libs && append-ldflags -static
	default
}

src_install() {
	einstalldocs
	dobin bsign_sign bsign_verify bsign_hash bsign_check
	newbin o/bsign-unstripped bsign
	doman bsign.1
}
