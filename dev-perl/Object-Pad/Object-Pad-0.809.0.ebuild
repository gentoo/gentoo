# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.809
inherit perl-module

DESCRIPTION="Simple syntax for lexical field-based objects"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=dev-perl/XS-Parse-Keyword-0.390.0
	>=dev-perl/XS-Parse-Sublike-0.150.0
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.400.400
	test? (
		>=virtual/perl-Test2-Suite-0.0.148
	)
"
