# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CJM
DIST_VERSION=1.400
inherit perl-module

DESCRIPTION="Read & write Palm OS databases (both PDB and PRC)"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="examples"

# Palm::Raw -> Palm-PDB
RDEPEND="
	virtual/perl-Exporter
	dev-perl/Palm-PDB
"
BDEPEND="
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
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
