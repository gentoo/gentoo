# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ISHIGAKI
DIST_VERSION=1.03
inherit perl-module

DESCRIPTION="Generate Kwalitee ratings for a distribution"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-perl/Archive-Any-Lite-0.60.0
	>=virtual/perl-Archive-Tar-1.760.0
	>=dev-perl/Array-Diff-0.40.0
	>=dev-perl/Class-Accessor-0.190.0
	dev-perl/Data-Binary
	>=dev-perl/File-Find-Object-0.2.1
	>=virtual/perl-Scalar-List-Utils-1.330.0
	dev-perl/Module-Find
	dev-perl/Parse-Distname
	>=dev-perl/Perl-PrereqScanner-NotQuiteLite-0.990.100
	>=dev-perl/Software-License-0.103.12
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/ExtUtils-MakeMaker-CPANfile-0.80.0
	test? (
		dev-perl/Test-FailWarnings
		>=dev-perl/Test-File-1.993.0
		>=virtual/perl-Test-Simple-0.880.0
	)
"
