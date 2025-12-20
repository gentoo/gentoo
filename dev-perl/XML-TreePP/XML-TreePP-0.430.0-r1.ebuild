# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_VERSION=0.43
DIST_AUTHOR=KAWASAKI
inherit perl-module

DESCRIPTION="Pure Perl implementation for parsing/writing XML documents"

SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ~riscv x86"

RDEPEND="
	dev-perl/libwww-perl
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PERL_RM_FILES=("t/00_pod.t")
