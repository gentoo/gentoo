# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=UMEMOTO
DIST_VERSION=0.29
inherit autotools perl-module toolchain-funcs

DESCRIPTION="IPv6 related part of the C socket.h defines and structure manipulators"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

PATCHES=(
	"${FILESDIR}"/${PN}-0.290.0-pointer-warning.patch
	"${FILESDIR}"/${PN}-0.290.0-which.patch
)

src_unpack() {
	default
	tc-export CC
}

src_prepare () {
	default
	eautoreconf
}
