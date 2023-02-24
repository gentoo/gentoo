# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	"reference:>=app-arch/bzip2-1.0.8-r4"
	"lbzip2:app-arch/lbzip2[-symlink(-)]"
	"pbzip2:app-arch/pbzip2[-symlink(-)]"
)

inherit app-alternatives

DESCRIPTION="bzip2 symlink"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="split-usr"

RDEPEND="
	!<app-arch/bzip2-1.0.8-r4
	!app-arch/lbzip2[symlink(-)]
	!app-arch/pbzip2[symlink(-)]
"

src_install() {
	local alt=$(get_alternative)
	local usr_prefix=
	use split-usr && usr_prefix=../usr/bin/

	case ${alt} in
		reference)
			dosym bzip2-reference /bin/bzip2
			alt=bzip2-reference
			;;
		*)
			dosym "${usr_prefix}${alt}" /bin/bzip2
			;;
	esac

	dosym bzip2 /bin/bunzip2
	dosym bzip2 /bin/bzcat

	newman - bzip2.1 <<<".so ${alt}.1"
	newman - bunzip2.1 <<<".so bzip2.1"
	newman - bzcat.1 <<<".so bzip2.1"
}
