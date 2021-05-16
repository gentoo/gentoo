# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Multithreaded tool for matching large sets of patterns against biosequence DBs"
HOMEPAGE="http://stephanopoulos.openwetware.org/BIOGREP.html"
SRC_URI="http://www.openwetware.org/images/3/3d/${P^}.tar.gz -> ${P}.tar.gz
	doc? ( http://www.openwetware.org/images/4/49/${PN^}.pdf -> ${P}.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	use doc && DOCS+=( "${DISTDIR}"/${P}.pdf )
	if use examples; then
		# remove cruft before installing examples
		find examples/ \( -name 'CVS' -o -name '*~' \) -exec rm -rf '{}' + || die

		DOCS+=( examples )
		docompress -x /usr/share/doc/${PF}/examples
	fi

	default
}
