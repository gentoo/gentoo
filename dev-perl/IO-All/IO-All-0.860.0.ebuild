# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-All/IO-All-0.860.0.ebuild,v 1.1 2015/07/04 13:31:03 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=INGY
MODULE_VERSION=0.86

inherit perl-module

DESCRIPTION="unified IO operations"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# needs Scalar::Util
DEPEND="
	virtual/perl-Scalar-List-Utils
"
RDEPEND="${DEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do parallel"
