# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PETDANCE
DIST_VERSION=1.16
inherit perl-module

DESCRIPTION="File::Next is an iterator-based module for finding files"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/perl-File-Spec"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

src_test() {
	# Ugh, Upstream has tests that depend on tests ...
	echo 'print qq[1..1\nok 1];' > "${S}/t/pod.t"
	echo 'print qq[1..1\nok 1];' > "${S}/t/pod-coverage.t"
	perl-module_src_test
}
