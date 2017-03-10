# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CJM
DIST_VERSION=1.400
inherit perl-module

DESCRIPTION="Read & write Palm OS databases (both PDB and PRC)"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test examples"

# Palm::Raw -> Palm-PDB
RDEPEND="
	virtual/perl-Exporter
	dev-perl/Palm-PDB
"
DEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
src_test() {
	perl_rm_files "t/pod.t" "t/pod_coverage.t"
	perl-module_src_test
}
src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}/examples/
		doins -r examples/*
	fi
}
