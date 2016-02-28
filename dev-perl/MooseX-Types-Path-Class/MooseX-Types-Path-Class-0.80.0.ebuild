# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="A Path::Class type library for Moose"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test minimal"

# Note: Will warn about missing Getopt during runtime
# due to https://rt.cpan.org/Ticket/Display.html?id=39327
RDEPEND="
	dev-perl/Moose
	dev-perl/MooseX-Types
	>=dev-perl/Path-Class-0.160.0
	virtual/perl-if
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.7.0
	test? (
		!minimal? ( dev-perl/MooseX-Getopt )
		virtual/perl-ExtUtils-MakeMaker
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.880.0
	)
"
