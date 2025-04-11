# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETJ
DIST_VERSION=2.003

inherit perl-module

DESCRIPTION="A PDL interface to the HDF4 library"

SLOT="0"
#KEYWORDS="~amd64"

RDEPEND="
	>=dev-perl/PDL-2.94.0
"
BDEPEND="${RDEPEND}
	dev-perl/Alien-HDF4
	dev-perl/ExtUtils-Depends
	virtual/perl-ExtUtils-MakeMaker
"
