# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="DSB"
DIST_VERSION="0.19"
inherit perl-module

DESCRIPTION="Advanced operations on path variables"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~alpha ~amd64"

DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"
