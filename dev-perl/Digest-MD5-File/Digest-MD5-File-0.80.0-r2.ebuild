# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DMUEY
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Perl extension for getting MD5 sums for files and urls"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	virtual/perl-Digest-MD5
	dev-perl/libwww-perl
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
