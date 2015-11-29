# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN=Module-Info
MODULE_AUTHOR=NEILB
MODULE_VERSION=0.37
inherit perl-module

DESCRIPTION="Information about Perl modules"

SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/B-Utils-0.270.0
	virtual/perl-Carp
	>=virtual/perl-File-Spec-0.800.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST="do parallel"
