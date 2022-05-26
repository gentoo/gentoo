# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Required attributes which fail only when trying to use them"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="minimal"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Moose-0.940.0
	>=dev-perl/aliased-0.300.0
	dev-perl/namespace-autoclean
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.37.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
		)
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.880.0
	)
"
