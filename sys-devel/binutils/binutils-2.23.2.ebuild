# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils/binutils-2.23.2.ebuild,v 1.15 2014/11/08 16:54:29 vapier Exp $

EAPI="4"

PATCHVER="1.0"
ELF2FLT_VER=""
inherit toolchain-binutils

# See #464152
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 -amd64-fbsd -sparc-fbsd -x86-fbsd"
