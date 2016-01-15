# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BBB
MODULE_VERSION=1.27
inherit perl-module

DESCRIPTION="perl module to do NFS (or not) locking"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"

SRC_TEST="do"
