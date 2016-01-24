# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_VERSION=0.05
MODULE_AUTHOR="SIMONFLK"
inherit perl-module

DESCRIPTION="Override subroutines in a module for unit testing"

SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc x86"
IUSE="test"

RDEPEND="
	dev-perl/CGI
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST="do"
