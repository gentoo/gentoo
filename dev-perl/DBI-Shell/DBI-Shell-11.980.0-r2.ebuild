# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DLAMBLEY
DIST_VERSION=11.98
inherit perl-module

DESCRIPTION="Interactive command shell for the DBI"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="minimal"

RDEPEND="
	!minimal? (
		dev-perl/TermReadKey
	)
	dev-perl/DBI
	>=dev-perl/File-HomeDir-0.500.0
	dev-perl/IO-Interactive
	dev-perl/IO-Tee
	dev-perl/Text-CSV_XS
	dev-perl/Text-Reform
"
BDEPEND="
	${RDEPEND}
	test? (
		>=virtual/perl-Getopt-Long-2.170.0
	)
"
