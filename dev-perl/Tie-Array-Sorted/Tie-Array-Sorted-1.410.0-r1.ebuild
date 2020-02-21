# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=TMTM
MODULE_VERSION=1.41
inherit perl-module

DESCRIPTION="An array which is kept sorted"

LICENSE="|| ( GPL-2 GPL-3 )" # GPL-2+
SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="test? ( virtual/perl-Test-Simple )"

SRC_TEST="do"

src_test() {
	perl_rm_files t/pod.t t/pod-coverage.t
	perl-module_src_test
}
