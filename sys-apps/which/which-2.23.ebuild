# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Prints out location of specified executables that are in your path"
HOMEPAGE="https://carlowood.github.io/which/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

src_configure() {
	tc-export AR

	# Workaround ancient getopt vs C23 (bug #954755)
	if use elibc_musl || \
		[[ ${CHOST} == *-solaris* ]] || \
		[[ ${CHOST} == *-darwin* ]]
	then
		append-cppflags -D__GNU_LIBRARY__
	fi

	CONFIG_SHELL="${BROOT}"/bin/bash econf
}
