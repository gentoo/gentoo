# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=OALDERS
MODULE_VERSION=1.50
inherit perl-module

DESCRIPTION="Detect browser, version, OS from UserAgent"

SLOT="0"
KEYWORDS="amd64 hppa ~mips ppc x86"
IUSE="test"

RDEPEND=""
DEPEND="
	dev-perl/Module-Build
	test? (
		dev-perl/File-Slurp
		virtual/perl-JSON-PP
		dev-perl/Test-NoWarnings
	)
"

SRC_TEST="do"
