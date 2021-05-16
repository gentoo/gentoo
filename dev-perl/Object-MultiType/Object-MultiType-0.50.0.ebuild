# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_VERSION=0.05
MODULE_AUTHOR=GMPASSOS
inherit perl-module

DESCRIPTION="Perl Objects as Hash, Array, Scalar, Code and Glob at the same time"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"

SRC_TEST=do
