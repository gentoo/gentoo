# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=HAARG
DIST_VERSION=2.003001
inherit perl-module

DESCRIPTION="efficient generation of subroutines via string eval"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~ia64 ppc ~ppc64 ~sparc x86"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="
	!<dev-perl/Moo-2.3.0
	!minimal? (
		>=dev-perl/Sub-Name-0.80.0
	)
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test-Fatal-0.3.0
		>=virtual/perl-Test-Simple-0.940.0
	)
"
