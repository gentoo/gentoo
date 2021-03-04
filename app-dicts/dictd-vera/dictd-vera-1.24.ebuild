# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="V.E.R.A. -- Virtual Entity of Relevant Acronyms for dict"
HOMEPAGE="http://home.snafu.de/ohei/vera/vueber-e.html"
SRC_URI="mirror://gnu/vera/vera-${PV}.tar.gz"

SLOT="0"
LICENSE="FDL-1.3"
KEYWORDS="amd64 ~ppc ~ppc64 sparc x86"

DEPEND=">=app-text/dictd-1.5.5"
RDEPEND="${DEPEND}"

S=${WORKDIR}/vera-${PV}
PATCHES=(
	"${FILESDIR}"/${P}-U+D7.patch
)

src_compile() {
	cat vera.[0-9a-z] | dictfmt -f -u http://home.snafu.de/ohei \
		-s "V.E.R.A. -- Virtual Entity of Relevant Acronyms" \
		vera || die
	dictzip -v vera.dict || die
}

src_install() {
	insinto /usr/lib/dict
	doins vera.dict.dz
	doins vera.index

	dodoc changelog README
}
