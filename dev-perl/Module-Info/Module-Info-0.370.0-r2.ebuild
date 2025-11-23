# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=0.37
inherit perl-module

DESCRIPTION="Information about Perl modules"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~mips ppc ppc64 x86"

RDEPEND="
	>=dev-perl/B-Utils-0.270.0
	virtual/perl-Carp
	>=virtual/perl-File-Spec-0.800.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PATCHES=("${FILESDIR}/${PN}-0.370.0-no-dot-inc.patch")

src_test() {
	perl_rm_files "t/zz_pod.t" "t/zy_pod_coverage.t"
	perl-module_src_test
}
