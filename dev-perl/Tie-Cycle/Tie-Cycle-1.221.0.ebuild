# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BDFOY
DIST_VERSION=1.221
inherit perl-module

DESCRIPTION="Cycle through a list of values via a scalar"

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
	perl-module_src_test
}
