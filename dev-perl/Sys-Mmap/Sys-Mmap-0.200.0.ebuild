# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TODDR
DIST_VERSION=0.20

inherit perl-module

DESCRIPTION="Uses mmap to map in a file as a Perl variable"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	virtual/perl-XSLoader
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
