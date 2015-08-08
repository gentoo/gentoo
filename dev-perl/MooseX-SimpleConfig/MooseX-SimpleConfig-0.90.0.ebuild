# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BOBTFISH
MODULE_VERSION=0.09
inherit perl-module

DESCRIPTION="A Moose role for setting attributes from a simple configfile"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/MooseX-ConfigFromFile-0.20.0
	>=dev-perl/Moose-0.350.0
	>=dev-perl/Config-Any-0.130.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"

SRC_TEST=do
