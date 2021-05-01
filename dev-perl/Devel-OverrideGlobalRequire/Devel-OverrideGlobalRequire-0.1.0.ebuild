# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.001
inherit perl-module

DESCRIPTION="Override CORE::GLOBAL::require safely"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-Scalar-List-Utils
		virtual/perl-Test-Simple
	)
"
