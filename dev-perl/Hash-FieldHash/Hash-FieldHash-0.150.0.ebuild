# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=GFUJI
DIST_VERSION=0.15
DIST_EXAMPLES=( "example/*" "benchmark" )
inherit perl-module

DESCRIPTION="Lightweight field hash for inside-out objects"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-XSLoader-0.20.0
	>=virtual/perl-parent-0.221.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-Devel-PPPort-3.190.0
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	>=virtual/perl-ExtUtils-ParseXS-2.210.0
	>=dev-perl/Module-Build-0.400.500
	test? (
		>=dev-perl/Test-LeakTrace-0.70.0
		>=virtual/perl-Test-Simple-0.620.0
	)
"

src_prepare() {
	# https://github.com/gfx/p5-Hash-FieldHash/issues/4
	sed -i -e 's/use builder::MyBuilder;/use lib q[.]; use builder::MyBuilder;/' Build.PL \
		|| die "Can't patch Build.PL for 5.26 dot-in-inc"

	perl-module_src_prepare
}
