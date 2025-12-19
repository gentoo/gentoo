# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_MODULE=data/
inherit xorg-3

DESCRIPTION="X.Org bitmaps data"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

# there is nothing to compile for this package, all its contents are produced by
# configure. the only make job that matters is make install
src_compile() { true; }
