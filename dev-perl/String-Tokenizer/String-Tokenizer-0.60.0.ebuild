# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=STEVAN
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="A simple string tokenizer"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
src_test() {
	perl_rm_files "t/release-pod.t" "t/release-pod_coverage.t"
	perl-module_src_test
}
