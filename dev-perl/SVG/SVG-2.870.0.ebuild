# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MANWAR
DIST_VERSION=2.87
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Perl extension for generating Scalable Vector Graphics (SVG) documents"

SLOT="0"
KEYWORDS="amd64 ppc ~x86"

RDEPEND="
	virtual/perl-parent
	virtual/perl-Scalar-List-Utils
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.940.0 )
"

src_test() {
	perl_rm_files t/96-perl-critic.t t/98-tidyall.t \
		t/99_test_pod_coverage.t \
		t/meta-json.t \
		t/meta-yml.t
	perl-module_src_test
}
