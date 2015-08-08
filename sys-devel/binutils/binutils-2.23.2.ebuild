# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

PATCHVER="1.0"
ELF2FLT_VER=""
inherit toolchain-binutils

# See #464152
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 -amd64-fbsd -sparc-fbsd -x86-fbsd"
