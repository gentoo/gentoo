# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DAGOLDEN
MODULE_VERSION=0.001
inherit perl-module

DESCRIPTION="Moose type constraints for strings or string-like objects"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/MooseX-Types
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		dev-perl/Moose
		virtual/perl-File-Temp
		>=virtual/perl-Test-Simple-0.960.0
	)
"

SRC_TEST=do
