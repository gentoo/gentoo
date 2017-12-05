# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SWALTERS
DIST_VERSION=0.19

inherit perl-module

DESCRIPTION="Uses mmap to map in a file as a Perl variable"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE="test"

RDEPEND="virtual/perl-XSLoader"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
