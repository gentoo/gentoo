# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=2.058
inherit perl-module

DESCRIPTION="Common tests to check syntax of your modules, using only core modules"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Data-Section-0.4.0
	>=dev-perl/Dist-Zilla-4.300.39
	dev-perl/Moose
	dev-perl/Path-Tiny
	dev-perl/Sub-Exporter-ForMethods
	dev-perl/namespace-autoclean
"
DEPEND="
	dev-perl/Module-Build-Tiny
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		>=dev-perl/CPAN-Meta-Check-0.11.0
		>=dev-perl/File-pushd-1.4.0
		>=virtual/perl-Module-CoreList-2.770.0
		>=dev-perl/Perl-PrereqScanner-1.16.0
		dev-perl/Test-Deep
		dev-perl/Test-MinimumVersion
		>=virtual/perl-Test-Simple-0.960.0
		>=dev-perl/Test-Warnings-0.9.0
	)
"
