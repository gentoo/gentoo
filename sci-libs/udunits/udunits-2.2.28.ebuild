# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fortran-2

DESCRIPTION="Library for manipulating units of physical quantities"
HOMEPAGE="https://www.unidata.ucar.edu/software/udunits/"
SRC_URI="ftp://ftp.unidata.ucar.edu/pub/udunits/${P}.tar.gz"

LICENSE="UCAR-BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~mips ppc ~sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-libs/expat"
DEPEND="${RDEPEND}"

src_configure() {
	econf --disable-static
}

src_install() {
	default

	local i
	for i in udunits2 udunits2-{accepted,base,common,derived,prefixes}; do
		dosym ../../udunits/"${i}".xml usr/share/doc/${PF}/"${i}".xml
	done

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
