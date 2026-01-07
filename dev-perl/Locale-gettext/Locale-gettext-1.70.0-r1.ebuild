# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_NAME=gettext
DIST_AUTHOR=PVANDRY
DIST_VERSION=1.07
inherit perl-module

DESCRIPTION="A Perl module for accessing the GNU locale utilities"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="
	sys-devel/gettext
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PATCHES=(
	"${FILESDIR}/${P}-no-dot-inc.patch"
	"${FILESDIR}/${P}-tests.patch"
)

S="${WORKDIR}/${PN}-${DIST_VERSION}"
