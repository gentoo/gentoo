# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=PIRZYK
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Filesys-Statvfs"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="virtual/perl-ExtUtils-MakeMaker"

PATCHES=( "${FILESDIR}/${P}-glibc226.patch" )
