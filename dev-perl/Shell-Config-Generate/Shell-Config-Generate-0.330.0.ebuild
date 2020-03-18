# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PLICEASE
DIST_VERSION=0.33
inherit perl-module

DESCRIPTION="Portably generate config for any shell"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/Shell-Guess"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test2-Suite-0.0.60
		>=virtual/perl-Test-Simple-1.302.15
	)
"
