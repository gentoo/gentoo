# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=SHARYANTO
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Extract probable dates from strings"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-Data-Inheritable
	>=dev-perl/DateTime-Format-Natural-0.600.0
	virtual/perl-Scalar-List-Utils
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? (
		dev-perl/Test-MockTime
		virtual/perl-Test-Simple
	)
"
