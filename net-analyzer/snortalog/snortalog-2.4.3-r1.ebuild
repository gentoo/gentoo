# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

MY_P="${PN}_v${PV}"

DESCRIPTION="a powerful perl script that summarizes snort logs"
HOMEPAGE="http://jeremy.chartier.free.fr/snortalog/"
SRC_URI="${HOMEPAGE}downloads/${PN}/${MY_P}.tar"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86"
IUSE="tk"

RDEPEND="
	dev-lang/perl[ithreads]
	dev-perl/HTML-HTMLDoc
	virtual/perl-DB_File
	virtual/perl-Getopt-Long
	tk? ( dev-perl/perl-tk dev-perl/GDGraph )
"

S=${WORKDIR}

src_prepare() {
	edos2unix $(find conf/ modules/ -type f) ${PN}.* CHANGES

	# fix paths, erroneous can access message
	sed -i \
		-e "s:\(modules/\):/usr/lib/snortalog/${PV}/\1:g" \
		-e 's:\($domains_file = "\)conf/\(domains\)\(".*\):\1/etc/snortalog/\2\3:' \
		-e 's:\($rules_file = "\)conf/\(rules\)\(".*\):\1/etc/snortalog/\2\3:' \
		-e 's:\($picts_dir ="\)picts\(".*\):\1/etc/snortalog/picts\2:' \
		-e 's:\($hw_file = "\)conf/\(hw\)\(".*\):\1/etc/snortalog/\2\3:' \
		-e 's:\($lang_file ="\)conf/\(lang\)\(".*\):\1/etc/snortalog/\2\3:' \
		-e 's:Can access:Cannot access:' \
		snortalog.pl || die
}

src_install () {
	dobin snortalog.pl

	insinto /etc/snortalog
	doins conf/{domains,hw,lang,rules}

	insinto /etc/snortalog/picts
	doins picts/*

	insinto /usr/lib/snortalog/${PV}/modules
	doins -r modules/*

	dodoc CHANGES doc/snortalog_v2.2.1.pdf
}
