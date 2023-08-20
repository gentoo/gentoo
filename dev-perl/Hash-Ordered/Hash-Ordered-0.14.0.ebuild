# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.014
inherit perl-module

DESCRIPTION="Fast, pure-Perl ordered hash class"

LICENSE="Apache-1.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ppc64 ~riscv x86"

RDEPEND="
	virtual/perl-Carp
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-Scalar-List-Utils
		dev-perl/Test-Deep
		dev-perl/Test-FailWarnings
		dev-perl/Test-Fatal
	)
"
