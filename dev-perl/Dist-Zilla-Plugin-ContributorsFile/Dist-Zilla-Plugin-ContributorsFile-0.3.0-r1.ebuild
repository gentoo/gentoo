# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=YANICK
DIST_VERSION=0.3.0
inherit perl-module

DESCRIPTION="add a file listing all contributors"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Dist-Zilla
	dev-perl/Moose
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"
