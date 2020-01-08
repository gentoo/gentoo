# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ADAMK
DIST_VERSION=1.08
inherit perl-module

DESCRIPTION="Generate syntax-hightlighted HTML for Perl using PPI"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/CSS-Tiny-1.100.0
	>=dev-perl/PPI-0.990.0
	>=dev-perl/Params-Util-0.50.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
	>=virtual/perl-File-Spec-0.800.0
	test? (
		>=virtual/perl-Test-Simple-0.470.0
	)
"

src_prepare() {
	sed -i -e 's/use inc::Module::Install;/use lib q[.]; use inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
