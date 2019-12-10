# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NEILB
DIST_VERSION=1.10
inherit perl-module

DESCRIPTION="Check for pod coverage in your distribution"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Test-Simple
	dev-perl/Pod-Coverage"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"

src_test() {
	perl_rm_files t/pod.t
	perl-module_src_test
}
