# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MANWAR
DIST_VERSION=0.17

inherit perl-module

DESCRIPTION="Validate and convert data types."
SLOT="0"
KEYWORDS="amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-perl/Module-Build"
BDEPEND="
	>=dev-perl/Module-Build-0.270.100
	test? (
		>=virtual/perl-Test-Simple-0.170.0
	)
"
PERL_RM_FILES=(
	"t/zpod.t"
)
