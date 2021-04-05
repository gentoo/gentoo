# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=GUIDO
DIST_VERSION=1.28
inherit perl-module

DESCRIPTION="High-Level Interface to Uniforum Message Translation"
HOMEPAGE="http://guido-flohr.net/projects/libintl-perl https://metacpan.org/release/libintl-perl"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="virtual/libintl"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PATCHES=( "${FILESDIR}/${P}-sanity-2.patch" )
