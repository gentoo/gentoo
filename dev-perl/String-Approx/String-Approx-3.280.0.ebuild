# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JHI
DIST_VERSION=3.28
inherit perl-module

DESCRIPTION="Perl extension for approximate string matching (fuzzy matching)"

LICENSE="|| ( Artistic-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 sparc x86"
IUSE="test"

DEPEND="virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )"
