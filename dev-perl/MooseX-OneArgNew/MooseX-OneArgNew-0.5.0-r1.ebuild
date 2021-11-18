# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=0.005
inherit perl-module

DESCRIPTION="teach ->new to accept single, non-hashref arguments"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="minimal"

RDEPEND="
	dev-perl/Moose
	>=dev-perl/MooseX-Role-Parameterized-1.10.0
	dev-perl/namespace-autoclean
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
		)
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
