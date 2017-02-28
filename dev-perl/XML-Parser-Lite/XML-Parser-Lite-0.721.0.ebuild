# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PHRED
DIST_VERSION=0.721
inherit perl-module

DESCRIPTION="Lightweight regexp-based XML parser"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="test minimal"

# Note: Don't try to depend on XMLRPC-Lite or SOAP-Lite with tests,
# as it it introduces a temporal cycle when enabled.
# Also: That test requires networking ...
RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test-Requires-0.60.0
		>=virtual/perl-Test-Simple-0.880.0
	)
"
src_test() {
	local my_test_control="${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}"
	if ! has network ${my_test_control} ; then
		einfo "removing tests that can do network IO"
		perl_rm_files "t/37-mod_xmlrpc.t"
	fi
	perl-module_src_test
}
