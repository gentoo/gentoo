# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=AUDREYT
MODULE_VERSION=1.33
inherit perl-module

DESCRIPTION="East Asian Width properties"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="virtual/perl-File-Spec"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"
PATCHES=("${FILESDIR}/no-dot-inc.patch")
SRC_TEST="do"
