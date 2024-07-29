# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DEXTER
DIST_VERSION=0.0701
inherit perl-module

DESCRIPTION="Store a Moose object in glob reference"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-perl/Moose-0.96"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		>=dev-perl/Test-Unit-Lite-0.12
		dev-perl/Test-Assert
		virtual/perl-parent
	)"
