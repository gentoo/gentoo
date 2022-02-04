# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_NAME=gettext
DIST_AUTHOR=PVANDRY
DIST_VERSION=1.07
inherit perl-module

DESCRIPTION="A Perl module for accessing the GNU locale utilities"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	sys-devel/gettext
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PATCHES=("${FILESDIR}/${P}-no-dot-inc.patch")

S="${WORKDIR}/${PN}-${DIST_VERSION}"
