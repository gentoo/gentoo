# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CHM
MODULE_VERSION=1.18
inherit perl-module

DESCRIPTION="Facilitate use of FORTRAN from Perl/XS code"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="virtual/perl-ExtUtils-MakeMaker"

SRC_TEST="do parallel"
