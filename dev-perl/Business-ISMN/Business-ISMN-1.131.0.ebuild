# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BDFOY
DIST_VERSION=1.131
inherit perl-module

DESCRIPTION="International Standard Music Numbers"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Tie-Cycle-1.210.0
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	virtual/perl-File-Spec
	test? ( >=virtual/perl-Test-Simple-0.950.0 )
"

src_prepare() {
	sed -i -e '/use Test::Manifest/d' \
		   -e '/test_manifest/d' \
		   Makefile.PL || die "Can't defang Test::Manifest"
	perl-module_src_prepare
}

src_test() {
	perl_rm_files t/pod.t t/pod_coverage.t
	perl-module_src_test
}
