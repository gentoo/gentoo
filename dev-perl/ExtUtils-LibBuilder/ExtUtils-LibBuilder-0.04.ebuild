# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="AMBS"
MODULE_SECTION="ExtUtils"

inherit perl-module

DESCRIPTION="A tool to build C libraries"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="virtual/perl-ExtUtils-CBuilder
	dev-perl/Module-Build
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	test? ( >=dev-perl/Test-Pod-1.22
		>=dev-perl/Test-Pod-Coverage-1.08 )"
RDEPEND=""

SRC_TEST="do"
