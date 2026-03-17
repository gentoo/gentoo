# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=3.005
inherit perl-module

DESCRIPTION="Tests to check your code against best practices"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Data-Section-0.4.0
	dev-perl/Dist-Zilla
	dev-perl/Moose
	dev-perl/Sub-Exporter-ForMethods
	dev-perl/namespace-autoclean
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		>=virtual/perl-Test-Simple-0.940.0
	)
"
