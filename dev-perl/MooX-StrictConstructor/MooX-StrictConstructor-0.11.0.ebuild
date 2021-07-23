# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HARTZELL
DIST_VERSION=0.011
inherit perl-module

DESCRIPTION="Make your Moo-based object constructors blow up on unknown attributes"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Class-Method-Modifiers
	>=dev-perl/Moo-1.1.0
	>=dev-perl/strictures-1.0.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.880.0
	)
"
