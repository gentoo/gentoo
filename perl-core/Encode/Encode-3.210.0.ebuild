# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DANKOGAI
DIST_VERSION=3.21
inherit perl-module

DESCRIPTION="Character encodings in Perl"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

PATCHES=(
	"${FILESDIR}"/gentoo_enc2xs.diff
)
