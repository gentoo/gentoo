# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=AKREAL
DIST_VERSION=0.23
inherit perl-module

DESCRIPTION="Run Perl program as a daemon process"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="minimal"

RDEPEND="!minimal? ( dev-perl/Proc-ProcessTable )"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
"
