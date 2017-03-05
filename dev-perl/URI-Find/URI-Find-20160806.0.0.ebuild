# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MSCHWERN
DIST_VERSION=20160806
inherit perl-module

DESCRIPTION="Find URIs in plain text"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-perl/URI-1.600.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.300.0
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"
