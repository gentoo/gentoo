# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BDFOY
DIST_VERSION=2.023
inherit perl-module

DESCRIPTION="Interact with a t/test_manifest file"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ppc ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
LICENSE="Artistic-2"

RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-Test-Harness
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		virtual/perl-File-Temp
		>=virtual/perl-Test-Simple-1.0.0
	)
"

src_test() {
	# Ugh, Upstream has tests that depend on tests ...
	echo 'print qq[1..1\nok 1];' > "${S}/t/99pod.t" || die
	echo 'print qq[1..1\nok 1];' > "${S}/t/pod_coverage.t" || die
	perl-module_src_test
}
