# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Perform two optimisations on a list of prefixes to reduce the length of the list"
HOMEPAGE="https://ftp.isc.org/isc/aggregate"
SRC_URI="https://ftp.isc.org/isc/aggregate/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ppc sparc x86"

RDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}"/${P}-build-fixup.patch
)

src_prepare() {
	default

	eautoreconf #871198
}

src_install() {
	dobin aggregate{,-ios}
	doman aggregate{,-ios}.1
	einstalldocs
}
