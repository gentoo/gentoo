# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-3

DESCRIPTION="X.Org bdftopcf application"
SRC_URI="https://xorg.freedesktop.org/archive/individual/util/${P}.tar.xz"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

DEPEND="x11-base/xorg-proto"
# RDEPEND=""
