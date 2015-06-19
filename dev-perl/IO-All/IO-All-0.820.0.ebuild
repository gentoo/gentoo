# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-All/IO-All-0.820.0.ebuild,v 1.1 2014/12/08 21:21:15 monsieurp Exp $

EAPI=5

MODULE_AUTHOR=FREW
MODULE_VERSION=0.82

inherit perl-module

DESCRIPTION="unified IO operations"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=virtual/perl-Scalar-List-Utils-1.380.0
	>=virtual/perl-File-Spec-3.480.0
"

REPDENDS="
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
"

SRC_TEST=do
