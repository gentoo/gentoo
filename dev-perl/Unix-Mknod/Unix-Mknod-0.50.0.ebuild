# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PIRZYK
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Perl extension for mknod, major, minor, and makedev"

SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="virtual/perl-ExtUtils-MakeMaker"
