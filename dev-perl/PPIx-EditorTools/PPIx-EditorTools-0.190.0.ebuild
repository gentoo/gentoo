# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=SZABGAB
MODULE_VERSION=0.18
inherit perl-module

DESCRIPTION="Utility methods and base class for manipulating Perl via PPI"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Class-XSAccessor-1.20.0
	>=dev-perl/PPI-1.215.0
	>=dev-perl/Try-Tiny-0.110.0
"
DEPEND="
	test? (
		${RDEPEND}
		dev-perl/Test-Most
		>=dev-perl/Test-Differences-0.480.100
		dev-perl/Test-NoWarnings
		dev-perl/CPAN-Changes
	)"

SRC_TEST=do
