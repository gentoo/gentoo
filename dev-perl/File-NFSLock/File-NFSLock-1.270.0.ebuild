# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=BBB
MODULE_VERSION=1.27
inherit perl-module

DESCRIPTION="perl module to do NFS (or not) locking"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"
PATCHES=( "${FILESDIR}/${PN}"-1.27-no-dot-inc.patch )
SRC_TEST="do"
