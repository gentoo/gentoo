# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}_v${PV}"

inherit edos2unix

DESCRIPTION="A powerful perl script that summarizes snort logs"
HOMEPAGE="http://jeremy.chartier.free.fr/snortalog/"
SRC_URI="http://jeremy.chartier.free.fr/snortalog/downloads/${PN}/${MY_P}.tar"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86"
IUSE="tk"

RDEPEND="
	dev-lang/perl[ithreads]
	dev-perl/GDGraph
	dev-perl/HTML-HTMLDoc
	virtual/perl-DB_File
	virtual/perl-Getopt-Long
	tk? ( dev-perl/Tk )
"

src_prepare() {
	default

	local convert=$(find conf/ modules/ -type f || die)
	convert+=( ${PN}.* CHANGES )

	local item
	for item in ${convert[@]} ; do
		edos2unix "${item}"
	done

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

src_install() {
	dobin snortalog.pl

	insinto /etc/snortalog
	doins conf/{domains,hw,lang,rules}

	insinto /etc/snortalog/picts
	doins picts/*

	insinto /usr/lib/snortalog/${PV}/modules
	doins -r modules/*

	dodoc CHANGES doc/snortalog_v2.2.1.pdf
}
