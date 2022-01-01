# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=PETDANCE
DIST_VERSION=1.18
inherit perl-module

DESCRIPTION="An iterator-based module for finding files"

LICENSE="Artistic-2 GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/perl-File-Spec"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-File-Temp-0.220.0
		>=virtual/perl-Test-Simple-0.880.0
	)
"

src_test() {
	# Ugh, Upstream has tests that depend on tests ...
	echo 'print qq[1..1\nok 1];' > "${S}/t/pod.t"
	echo 'print qq[1..1\nok 1];' > "${S}/t/pod-coverage.t"
	perl-module_src_test
}
