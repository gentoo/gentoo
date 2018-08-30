# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NI-S
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="Utility for looking for perl objects that are not reclaimed"

SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 sparc x86"

DEPEND="virtual/perl-ExtUtils-MakeMaker"
