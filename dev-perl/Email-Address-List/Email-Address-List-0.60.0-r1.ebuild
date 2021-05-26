# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BPS
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="RFC close address list parsing"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/Email-Address"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		dev-perl/JSON
		virtual/perl-Test-Simple
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.06-no-dot-inc.patch"
)
