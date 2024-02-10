# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MSCHOUT
DIST_VERSION=1.61

inherit perl-module

DESCRIPTION="Expand template text with embedded Perl"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ppc ~ppc64 ~riscv x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Encode
	virtual/perl-Exporter
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Temp
		virtual/perl-Safe
		dev-perl/Test-More-UTF8
		virtual/perl-Test-Simple
		dev-perl/Test-Warnings
	)
"

PERL_RM_FILES=( "t/author-pod-syntax.t" "t/author-signature.t" )
