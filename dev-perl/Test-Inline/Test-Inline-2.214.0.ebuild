# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=2.214
inherit perl-module

DESCRIPTION="Inline test suite support for Perl"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	>=dev-perl/Algorithm-Dependency-1.20.0
	>=dev-perl/Config-Tiny-2.0.0
	>=dev-perl/File-Find-Rule-0.260.0
	>=dev-perl/File-Flat-1.0.0
	>=dev-perl/File-Remove-0.370.0
	>=virtual/perl-File-Spec-0.800.0
	>=dev-perl/File-chmod-0.310.0
	>=virtual/perl-Getopt-Long-2.340.0
	>=virtual/perl-Scalar-List-Utils-1.190.0
	>=dev-perl/Params-Util-0.210.0
	dev-perl/Path-Tiny
"
BDEPEND="${RDEPEND}
	test? (
		>=dev-perl/Test-ClassAPI-1.20.0
		>=virtual/perl-Test-Simple-0.420.0
		>=dev-perl/Test-Script-1.20.0
	)
"

# Parallel tests unsupported: https://bugs.gentoo.org/663272
DIST_TEST="do"
