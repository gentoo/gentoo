# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=LBROCARD
MODULE_VERSION=2.02
inherit perl-module

DESCRIPTION="help when paging through sets of results"

SLOT="0"
KEYWORDS="amd64 ~x86 ~ppc-aix ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/Class-Accessor-Chained"
DEPEND="dev-perl/Module-Build
	test? (
		${RDEPEND}
		dev-perl/Test-Exception
	)"

SRC_TEST=do

src_test() {
	perl_rm_files t/pod.t t/pod-coverage.t
	perl-module_src_test
}
