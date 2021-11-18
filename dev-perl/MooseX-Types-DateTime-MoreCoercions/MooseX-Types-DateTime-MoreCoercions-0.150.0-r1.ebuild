# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="Extensions to MooseX::Types::DateTime"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/DateTime-0.430.200
	>=dev-perl/DateTimeX-Easy-0.85.0
	>=dev-perl/Moose-0.410.0
	>=dev-perl/MooseX-Types-0.40.0
	>=dev-perl/MooseX-Types-DateTime-0.70.0
	>=dev-perl/Time-Duration-Parse-0.60.0
	virtual/perl-if
	>=dev-perl/namespace-clean-0.190.0
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.7.0
	test? (
		virtual/perl-ExtUtils-MakeMaker
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-1.1.10
	)
"
