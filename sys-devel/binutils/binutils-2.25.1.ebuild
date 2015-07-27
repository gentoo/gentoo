# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/binutils/binutils-2.25.1.ebuild,v 1.1 2015/07/27 03:27:18 vapier Exp $

EAPI="4"

PATCHVER="1.0"
ELF2FLT_VER=""
inherit toolchain-binutils

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd -sparc-fbsd ~x86-fbsd"
