# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.008
inherit perl-module

DESCRIPTION="Add test failures if warnings are caught"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
LICENSE="Apache-2.0"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-File-Spec
	>=virtual/perl-Test-Simple-0.860.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Capture-Tiny-0.120.0
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-Scalar-List-Utils
		>=virtual/perl-Test-Simple-0.960.0
	)
"
