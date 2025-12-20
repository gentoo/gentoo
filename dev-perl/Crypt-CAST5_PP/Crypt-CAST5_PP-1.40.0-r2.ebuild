# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BOBMATH
DIST_VERSION=1.04
inherit perl-module

DESCRIPTION="CAST5 block cipher in pure Perl"

SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		>=virtual/perl-Test-Simple-0.480.0
		dev-perl/Test-Taint
	)
"
