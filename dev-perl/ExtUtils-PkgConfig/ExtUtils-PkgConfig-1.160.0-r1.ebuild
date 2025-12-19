# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=XAOC
DIST_VERSION=1.16
inherit perl-module

DESCRIPTION="Simplistic perl interface to pkg-config"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	virtual/pkgconfig
"
