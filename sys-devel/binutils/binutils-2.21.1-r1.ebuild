# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils/binutils-2.21.1-r1.ebuild,v 1.13 2014/11/08 16:54:29 vapier Exp $

EAPI="4"

PATCHVER="1.4"
ELF2FLT_VER=""
inherit toolchain-binutils

KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 -sparc-fbsd -x86-fbsd"
