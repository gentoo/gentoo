# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	"flex:>=sys-devel/flex-2.6.4-r5"
	reflex:sys-devel/reflex
)

inherit app-alternatives

DESCRIPTION="lex symlinks"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="
	!<sys-devel/flex-2.6.4-r5
"

src_install() {
	local alt=$(get_alternative)

	dosym "${alt}" /usr/bin/lex
	newman - lex.1 <<<".so ${alt}.1"

	newenvd - 90lex <<-EOF
		LEX=${alt}
	EOF
}
