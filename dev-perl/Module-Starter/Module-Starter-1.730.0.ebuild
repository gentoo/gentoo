# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DBOOK
DIST_VERSION=1.73
inherit perl-module

DESCRIPTION="A simple starter kit for any module"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-File-Spec
	virtual/perl-Getopt-Long
	dev-perl/Module-Runtime
	>=virtual/perl-Pod-Parser-1.210.0
	virtual/perl-parent
	>=virtual/perl-version-0.770.0
"
DEPEND="${RDEPEND}
	test? (
		virtual/perl-Test-Simple
		>=virtual/perl-Test-Harness-0.210.0
	)
"
src_test() {
	perl_rm_files t/pod.t t/pod-coverage.t
	perl-module_src_test
}
