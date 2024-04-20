# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	"reference:>=dev-build/ninja-1.11.1-r3"
	samurai:dev-build/samurai
)

inherit app-alternatives

DESCRIPTION="ninja symlinks"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="!<dev-build/ninja-1.11.1-r3"

src_install() {
	local alt=$(get_alternative)

	case ${alt} in
		reference) alt=ninja-reference;;
		samurai) alt=samu;;
	esac

	dosym "${alt}" /usr/bin/ninja
}
