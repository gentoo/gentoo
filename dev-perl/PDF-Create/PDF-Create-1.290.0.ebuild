# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MANWAR
DIST_VERSION=1.29
inherit perl-module

DESCRIPTION="Create PDF documents in Perl"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE="test examples"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test-LeakTrace-0.140.0
		>=virtual/perl-Test-Simple-1.0.0
	)
"
src_test() {
	perl_rm_files "t/changes.t" "t/meta-json.t" "t/meta-yml.t" "t/pod.t" "t/manifest.t"
	perl-module_src_test
}
src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples/
		dodoc -r eg/*
	fi
}
