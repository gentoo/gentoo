# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ADAMK
DIST_VERSION=1.03
inherit perl-module

DESCRIPTION="Lets your class/object say it works like something else"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
	test? (
		>=virtual/perl-File-Spec-0.800.0
		>=virtual/perl-Test-Simple-0.470.0
	)
"
src_prepare() {
	sed -i -e 's/use inc::Module::Install::DSL;/use lib q[.];\nuse inc::Module::Install::DSL;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
