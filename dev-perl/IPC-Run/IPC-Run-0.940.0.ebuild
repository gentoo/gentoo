# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=TODDR
MODULE_VERSION=0.94
inherit perl-module

DESCRIPTION="system() and background procs w/ piping, redirs, ptys"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-perl/IO-Tty-1.80.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
		>=virtual/perl-Test-Simple-0.470.0
	)
"

SRC_TEST="do parallel"
