# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=HAARG
DIST_VERSION=0.35
inherit perl-module

DESCRIPTION="Pragma to use the C3 method resolution order algortihm"

SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 ~sparc x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

# Note: https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/dev-perl/Class-C3#Bundling
RDEPEND="
	>=dev-perl/Algorithm-C3-0.70.0
	virtual/perl-Scalar-List-Utils
"

BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.470.0
	)
"
