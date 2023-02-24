# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	"reference:>=app-arch/gzip-1.12-r3"
	"pigz:app-arch/pigz[-symlink(-)]"
)

inherit app-alternatives

DESCRIPTION="gzip symlinks"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="split-usr"

RDEPEND="
	!<app-arch/gzip-1.12-r3
	!app-arch/pigz[symlink(-)]
"

src_install() {
	local usr_prefix=
	use split-usr && usr_prefix=../usr/bin/

	case $(get_alternative) in
		pigz)
			dosym "${usr_prefix}pigz" /bin/gzip
			dosym gzip /bin/gunzip
			dosym gzip /bin/zcat
			newman - gzip.1 <<<".so pigz.1"
			;;
		reference)
			dosym gzip-reference /bin/gzip
			# gzip uses shell wrappers rather than argv[0]
			dosym gunzip-reference /bin/gunzip
			dosym zcat-reference /bin/zcat
			newman - gzip.1 <<<".so gzip-reference.1"
			;;
	esac

	newman - gunzip.1 <<<".so gzip.1"
	newman - zcat.1 <<<".so gzip.1"
}
