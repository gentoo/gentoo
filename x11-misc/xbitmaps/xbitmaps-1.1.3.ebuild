# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_MODULE=data/
XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="X.Org bitmaps data"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris ~x86-winnt"

# there is nothing to compile for this package, all its contents are produced by
# configure. the only make job that matters is make install
src_compile() { true; }
