# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools flag-o-matic

DESCRIPTION="embed secure hashes (SHA1) and digital signatures (GNU Privacy Guard) into files"
HOMEPAGE="http://packages.debian.org/sid/bsign"
SRC_URI="mirror://debian/pool/main/b/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc-macos ~x86 ~x86-linux"
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
