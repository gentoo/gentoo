# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=UMEMOTO
DIST_VERSION=0.28
inherit perl-module toolchain-funcs

DESCRIPTION="IPv6 related part of the C socket.h defines and structure manipulators"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE=""

src_unpack() {
	default
	tc-export CC
}
