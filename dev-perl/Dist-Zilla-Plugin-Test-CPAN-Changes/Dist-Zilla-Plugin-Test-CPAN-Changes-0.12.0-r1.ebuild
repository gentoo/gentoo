# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DOHERTY
DIST_VERSION=0.012
inherit perl-module

DESCRIPTION="release tests for your changelog"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Data-Section
	>=dev-perl/Dist-Zilla-4
	dev-perl/Moose
	>=dev-perl/CPAN-Changes-0.190.0
"
BDEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.940.0
	)
"
