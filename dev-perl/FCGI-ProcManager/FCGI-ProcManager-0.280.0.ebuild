# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ARODLAND
DIST_VERSION=0.28
inherit perl-module

DESCRIPTION="A FastCGI process manager"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"
