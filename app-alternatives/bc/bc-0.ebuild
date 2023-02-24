# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	"gnu:>=sys-devel/bc-1.07.1-r6"
	gh:sci-calculators/bc-gh
)

inherit app-alternatives

DESCRIPTION="bc symlink"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	!<sys-devel/bc-1.07.1-r6
"

src_install() {
	local suffix=$(get_alternative)
	[[ ${suffix} == gnu ]] && suffix=reference

	dosym "bc-${suffix}" /usr/bin/bc
	dosym "dc-${suffix}" /usr/bin/dc
	newman - bc.1 <<<".so bc-${suffix}.1"
	newman - dc.1 <<<".so dc-${suffix}.1"
}
