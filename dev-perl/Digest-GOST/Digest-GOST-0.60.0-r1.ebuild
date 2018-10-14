# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=GRAY
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="Perl interface to the GOST R 34.11-94 digest algorithm"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE="test"

RDEPEND="
	virtual/perl-Digest
	virtual/perl-XSLoader
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.820.0
	)
"
PATCHES=( "${FILESDIR}/${P}-bigendian-link.patch" )
