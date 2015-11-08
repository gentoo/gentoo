# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=PETDANCE
MODULE_VERSION=1.04
inherit perl-module

DESCRIPTION="Check for memory leaks and circular memory references"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND=">=dev-perl/Devel-Cycle-1.04
	>=virtual/perl-Test-Simple-0.62"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"

SRC_TEST="do"
