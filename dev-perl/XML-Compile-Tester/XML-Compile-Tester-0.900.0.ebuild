# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MARKOV
DIST_VERSION=0.90
inherit perl-module

DESCRIPTION="Support XML::Compile related regression testing"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Log-Report-0.170.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.540.0
	)
"
src_test() {
	perl_rm_files t/99pod.t
	perl-module_src_test
}
