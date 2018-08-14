# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CORION
DIST_VERSION=0.20
inherit perl-module

DESCRIPTION="Test fallback behaviour in absence of modules"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="test"

RDEPEND=""
DEPEND="virtual/perl-ExtUtils-MakeMaker"
