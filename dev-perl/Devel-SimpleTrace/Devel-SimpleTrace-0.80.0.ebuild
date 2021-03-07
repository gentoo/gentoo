# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SAPER
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="See where you code warns and dies using stack traces"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Data-Dumper
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.0
	test? (
		virtual/perl-Test-Simple
	)
"
