# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BBB
DIST_VERSION=1.29
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="perl module to do NFS (or not) locking"

SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="virtual/perl-ExtUtils-MakeMaker"
