# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CHROMATIC
DIST_VERSION=1.20200122
inherit perl-module

DESCRIPTION="Perl extension for emulating troublesome interfaces"

SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ~ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Scalar-List-Utils
	>=dev-perl/UNIVERSAL-can-1.201.106.170
	>=dev-perl/UNIVERSAL-isa-1.201.106.140
	virtual/perl-Test-Simple
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test-Exception-0.310.0
		>=virtual/perl-Test-Simple-0.980.0
		>=dev-perl/Test-Warn-0.230.0
	)
"
