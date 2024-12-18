# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ETHER
DIST_VERSION=0.2311
inherit perl-module

DESCRIPTION="File::Temp can be used to create and open temporary files in a safe way"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE=""

PATCHES=(
	# bug #390719
	"${FILESDIR}/${PN}-0.230.0-symlink-safety.patch"
	# bug #930949
	"${FILESDIR}/${PN}-0.231.100-pathconf-_PC_CHOWN_RESTRICTED.patch"
)
