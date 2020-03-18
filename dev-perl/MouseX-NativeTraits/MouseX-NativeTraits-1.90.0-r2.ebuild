# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=GFUJI
DIST_VERSION=1.09
DIST_EXAMPLES=("example/* benchmarks")
inherit perl-module

DESCRIPTION="Extend your attribute interfaces for Mouse"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Mouse-0.820.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Any-Moose-0.130.0
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		>=dev-perl/Test-Fatal-0.3.0
		>=virtual/perl-Test-Simple-0.880.0
	)
"
src_prepare() {
	sed -i -e 's/use inc::Module::Install /use lib q[.];\nuse inc::Module::Install /' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
