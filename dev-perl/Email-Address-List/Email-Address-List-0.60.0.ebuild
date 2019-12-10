# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BPS
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="RFC close address list parsing"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/Email-Address"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/JSON
		virtual/perl-Test-Simple
	)
"
src_prepare() {
	sed 's/use inc::Module::Install;/use lib q[.];\nuse inc::Module::Install;/' \
		-i Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26+ dot-in-inc"
	perl-module_src_prepare
}
