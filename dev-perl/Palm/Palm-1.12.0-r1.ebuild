# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN=p5-Palm
MODULE_AUTHOR=BDFOY
MODULE_VERSION=1.012
inherit perl-module

DESCRIPTION="Perl Module for Palm Pilots"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="amd64 ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( virtual/perl-Test-Simple )"

SRC_TEST=do

src_test() {
	perl_rm_files "t/pod.t" "t/pod_coverage.t"
	perl-module_src_test
}
