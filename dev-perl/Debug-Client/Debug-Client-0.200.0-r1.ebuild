# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BOWTIE
MODULE_VERSION=0.20
inherit perl-module

DESCRIPTION="Client side code for perl debugger"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="
	test? (
		>=dev-perl/Test-Class-0.360.0
		dev-perl/File-HomeDir
		>=dev-perl/PadWalker-1.920.0
		>=dev-perl/Test-Deep-0.108.0
		>=dev-perl/Term-ReadLine-Perl-1.30.300
	)"

SRC_TEST=do
