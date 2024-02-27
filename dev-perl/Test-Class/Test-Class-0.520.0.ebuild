# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SZABGAB
DIST_VERSION=0.52
inherit perl-module

DESCRIPTION="Easily create test classes in an xUnit/JUnit style"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	>=virtual/perl-Attribute-Handlers-0.770.0
	virtual/perl-Carp
	virtual/perl-File-Spec
	>=dev-perl/MRO-Compat-0.110.0
	dev-perl/Module-Runtime
	>=virtual/perl-Storable-2.40.0
	>=virtual/perl-Test-Simple-0.780.0
	dev-perl/Try-Tiny
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-IO
		virtual/perl-Test-Simple
		>=dev-perl/Test-Exception-0.250.0
	)
"
