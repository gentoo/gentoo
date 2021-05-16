# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SSOTKA
DIST_VERSION=0.05
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Perl extension for refactoring Perl code"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		>=virtual/perl-Test-Simple-0.470.0
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.50.0-perl526.patch"
)
