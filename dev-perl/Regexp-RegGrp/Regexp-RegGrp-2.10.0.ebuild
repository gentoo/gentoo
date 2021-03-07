# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=LEEJO
DIST_VERSION=2.01
inherit perl-module

DESCRIPTION="Groups a regular expressions collection"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}
