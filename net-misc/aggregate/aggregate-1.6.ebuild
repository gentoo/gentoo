# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Perform two optimisations on a list of prefixes to reduce the length of the list"
HOMEPAGE="https://ftp.isc.org/isc/aggregate"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc sparc x86"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND=""

PATCHES=( "${FILESDIR}/${P}-build-fixup.patch" )

src_configure() {
	tc-export CC
	econf
}

src_install() {
	dobin aggregate{,-ios}
	doman aggregate{,-ios}.1
	einstalldocs
}
