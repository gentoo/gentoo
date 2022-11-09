# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-3

DESCRIPTION="X.Org bdftopcf application"
SRC_URI="https://xorg.freedesktop.org/archive/individual/util/${P}.tar.xz"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

DEPEND="x11-base/xorg-proto"
RDEPEND=""
