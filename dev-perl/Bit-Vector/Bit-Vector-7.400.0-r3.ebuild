# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=STBEY
DIST_VERSION=7.4
inherit perl-module

DESCRIPTION="Efficient bit vector, set of integers and big int math library"

# License note: upstream mess, bug #721222, upstream is fine with "perl"
# https://rt.cpan.org/Public/Bug/Display.html?id=132512

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/Carp-Clan-5.300.0
	>=virtual/perl-Storable-2.210.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
