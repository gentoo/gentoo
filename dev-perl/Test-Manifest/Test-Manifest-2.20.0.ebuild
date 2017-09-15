# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=BDFOY
MODULE_VERSION=2.02
inherit perl-module

DESCRIPTION="Interact with a t/test_manifest file"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND="
	>=virtual/perl-Test-Simple-0.950.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do"

src_test() {
	# Ugh, Upstream has tests that depend on tests ...
	echo 'print qq[1..1\nok 1];' > "${S}/t/99pod.t"
	echo 'print qq[1..1\nok 1];' > "${S}/t/pod_coverage.t"
	perl-module_src_test
}
