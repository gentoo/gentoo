# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MATTLAW
MODULE_VERSION=1.09
inherit perl-module

DESCRIPTION="Module name tools and transformations"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="
	>=dev-perl/Module-Build-0.400.0
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST=do

src_test() {
	perl_rm_files "t/99..pod.t"
	perl-module_src_test
}
