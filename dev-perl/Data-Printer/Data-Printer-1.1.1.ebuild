# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GARU
DIST_VERSION=1.001001
DIST_EXAMPLES=( "examples/*" )
inherit perl-module

DESCRIPTION="Colored and full-featured pretty print of Perl data structures and objects"

SLOT="0"
KEYWORDS="~amd64 ~loong ~riscv ~x86"

RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	virtual/perl-Scalar-List-Utils
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Temp
		virtual/perl-Test-Simple
	)
"
