# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="An ISO 3166 country code finder"
HOMEPAGE="http://www.grigna.com/diego/linux/countrycodes/"
SRC_URI="http://www.grigna.com/diego/linux/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

S="${WORKDIR}"/${P}/src

PATCHES=( "${FILESDIR}"/${PV}-Makefile.patch )

src_prepare() {
	default
	tc-export CC
}

src_install() {
	emake \
		prefix="${D}/usr" \
		mandir="${D}/usr/share/man/man1" install
	dosym iso3166 /usr/bin/countrycodes
	dosym iso3166.1 /usr/share/man/man1/countrycodes
	dodoc ../doc/{Changelog,README}
	prepman
}
