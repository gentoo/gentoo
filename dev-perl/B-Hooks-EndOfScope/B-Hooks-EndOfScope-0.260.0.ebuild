# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=0.26
inherit perl-module

DESCRIPTION="Execute code after a scope finished compilation"

SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="
	>=dev-perl/Module-Implementation-0.50.0
	virtual/perl-Scalar-List-Utils
	>=dev-perl/Sub-Exporter-Progressive-0.1.6
	>=dev-perl/Variable-Magic-0.480.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Text-ParseWords
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.880.0
	)
"
