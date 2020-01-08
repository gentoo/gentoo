# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="DWHEELER"
MODULE_VERSION="0.09"

inherit perl-module

DESCRIPTION="Validate and convert data types."
SLOT="0"
KEYWORDS="amd64"
IUSE="test"
RESTRICT="!test? ( test )"
SRC_TEST=do
DEPEND="dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )"

src_test() {
	perl_rm_files t/zpod.t
	perl-module_src_test
}
