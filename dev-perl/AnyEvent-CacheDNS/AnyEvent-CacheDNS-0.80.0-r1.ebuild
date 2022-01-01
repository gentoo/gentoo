# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=POTYL
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Simple DNS resolver with caching"

SLOT="0"
KEYWORDS="~amd64 ~x86"
# License note: says 'perl 5.8.8 or any later' bug #718946
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/AnyEvent
"
BDEPEND="${RDEPEND}
	virtual/perl-File-Spec
	>=dev-perl/Module-Build-0.400.0
	test? ( virtual/perl-Test-Simple )
"
src_test() {
	local my_test_control=${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}
	if has network ${my_test_control}; then
		perl-module_src_test
	else
		einfo "Tests skipped without DIST_TEST_OVERRIDE =~ network: Fails under network sandboxing"
	fi
}
