# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MLEHMANN
MODULE_VERSION=1.0
inherit perl-module

DESCRIPTION="simple data types for common serialisation formats"

SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~x64-macos ~x86-solaris"
IUSE=""

RDEPEND="
	dev-perl/common-sense
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
