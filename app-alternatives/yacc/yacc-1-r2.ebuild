# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	"bison:>=sys-devel/bison-3.8.2-r1"
	byacc:dev-util/byacc
	"reference:>=dev-util/yacc-1.9.1-r7"
)

inherit app-alternatives

DESCRIPTION="yacc symlinks"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	!<dev-util/yacc-1.9.1-r7
	!<sys-devel/bison-3.8.2-r1
"

src_install() {
	local alt=$(get_alternative)

	case ${alt} in
		# bison installs its own small wrapper script 'yacc-bison'
		# around bison(1).
		bison) alt=yacc.bison;;
		reference) alt=yacc-reference;;
	esac

	dosym "${alt}" /usr/bin/yacc
	newman - yacc.1 <<<".so ${alt}.1"

	# Leaving this for now to be safe, as it's closer to pre-alternatives
	# status quo to leave it unset and let autoconf probe for Bison by itself
	# as it prefers it anyway, and might be a CPP-like situation wrt
	# calling bison or bison -y if YACC is set.
	if [[ ${alt} != yacc.bison ]]; then
		newenvd - 90yacc <<-EOF
			YACC=${alt}
		EOF
	fi
}
