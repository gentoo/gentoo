# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=HAARG
DIST_VERSION=0.10014
inherit perl-module

DESCRIPTION="Lets you build groups of accessors"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~ppc-aix ~ppc-macos ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Module-Runtime-0.12.0
	>=dev-perl/Class-XSAccessor-1.190.0
	>=dev-perl/Sub-Name-0.50.0
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		>=dev-perl/Test-Exception-0.310.0
		>=virtual/perl-Test-Simple-0.880.0
	)
"
