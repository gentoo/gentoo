# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Name your accessors get_foo() and set_foo(), whatever that may mean"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ppc64 x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Moose-1.160.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.310.0
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"
src_test() {
	perl_rm_files t/release-*.t
	perl-module_src_test
}
