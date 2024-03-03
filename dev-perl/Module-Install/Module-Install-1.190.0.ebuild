# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=1.19
inherit perl-module

DESCRIPTION="Standalone, extensible Perl module installer"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux"

RDEPEND="
	>=virtual/perl-CPAN-Meta-1.441.300
	>=virtual/perl-Devel-PPPort-3.160.0
	>=virtual/perl-ExtUtils-Install-1.520.0
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	>=virtual/perl-ExtUtils-ParseXS-2.190.0
	>=dev-perl/File-Remove-1.420.0
	>=virtual/perl-File-Spec-3.280.0
	>=dev-perl/Module-Build-0.290.0
	>=virtual/perl-Module-CoreList-2.170.0
	>=dev-perl/Module-ScanDeps-1.90.0
	>=virtual/perl-Parse-CPAN-Meta-1.441.300
	>=dev-perl/YAML-Tiny-1.380.0
	>=dev-perl/Archive-Zip-1.370.0
	>=dev-perl/File-HomeDir-1
	>=dev-perl/JSON-2.900.0
	>=dev-perl/libwww-perl-6
	>=dev-perl/PAR-Dist-0.290.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	virtual/perl-autodie
	>=dev-perl/YAML-Tiny-1.330.0
	test? (
		>=virtual/perl-Test-Harness-3.130.0
		>=virtual/perl-Test-Simple-0.860.0
	)
"
