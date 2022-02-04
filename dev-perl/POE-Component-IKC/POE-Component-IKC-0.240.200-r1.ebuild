# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GWYN
DIST_VERSION=0.2402
DIST_EXAMPLES=( "eg/*" )
inherit perl-module

DESCRIPTION="Inter-Kernel Communication for POE"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	>=dev-perl/Data-Dump-1.0.0
	>=dev-perl/Devel-Size-0.770.0
	>=dev-perl/POE-1.311.0
	>=virtual/perl-Scalar-List-Utils-1.0.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (	>=virtual/perl-Test-Simple-0.600.0 )
"

PERL_RM_FILES=( t/01_pod.t t/02_pod_coverage.t )

src_install() {
	perl-module_src_install
	dodoc FUTUR ikc-architecture.txt
}
