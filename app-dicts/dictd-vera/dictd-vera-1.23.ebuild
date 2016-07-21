# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="V.E.R.A. -- Virtual Entity of Relevant Acronyms for dict"
HOMEPAGE="http://home.snafu.de/ohei/vera/vueber-e.html"
SRC_URI="mirror://gnu/vera/vera-${PV}.tar.gz"

SLOT="0"
LICENSE="FDL-1.3"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND=">=app-text/dictd-1.5.5"
RDEPEND="${DEPEND}"

S=${WORKDIR}/vera-${PV}

src_compile () {
#	sed -f debian/dict-vera/sedfile vera.? >vera1 || die
#	sed '1,2!s/^/   /' vera. > vera || die
#	cat vera1>>vera || die
	cat vera.[0-9a-z] | /usr/bin/dictfmt -f -u http://home.snafu.de/ohei \
		-s "V.E.R.A. -- Virtual Entity of Relevant Acronyms" \
	   vera || die
	/usr/bin/dictzip -v vera.dict || die
}

src_install () {
	dodir /usr/lib/dict
	insinto /usr/lib/dict
	doins vera.dict.dz
	doins vera.index
	dodoc changelog README
}
