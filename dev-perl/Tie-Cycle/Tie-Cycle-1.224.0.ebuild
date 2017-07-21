# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BDFOY
DIST_VERSION=1.224
inherit perl-module

DESCRIPTION="Cycle through a list of values via a scalar"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="virtual/perl-Carp"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	virtual/perl-File-Spec
	test? (
		>=virtual/perl-Test-Simple-0.950.0
	)
"
src_test() {
	perl_rm_files t/pod_coverage.t t/pod.t
	sed -i -e '/^pod/d' t/test_manifest || die "Can't patch test_manifest"
	perl-module_src_test
}
