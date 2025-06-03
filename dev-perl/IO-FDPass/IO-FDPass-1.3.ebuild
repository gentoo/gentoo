# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="MLEHMANN"
DIST_VERSION=1.3
DIST_TEST="do parallel"
inherit perl-module

DESCRIPTION="Pass a file descriptor to another process, using a unix domain socket"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-perl/Canary-Stability
	virtual/perl-ExtUtils-MakeMaker
"
RDEPEND="$DEPEND"
