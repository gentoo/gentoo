# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAVECROSS
DIST_VERSION=0.12
inherit perl-module

DESCRIPTION="Syndication feed auto-discovery"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Class-ErrorHandler
	dev-perl/HTML-Parser
	dev-perl/libwww-perl
	dev-perl/URI
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		dev-perl/Test-LWP-UserAgent
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-0.07-no-dot-inc.patch"
)
