# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	"gnu:>=app-arch/cpio-2.13-r4"
	libarchive:app-arch/libarchive
)

inherit app-alternatives

DESCRIPTION="CPIO symlink"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="split-usr"

RDEPEND="
	!<app-arch/cpio-2.13-r4
"

src_install() {
	local usr_prefix=
	use split-usr && usr_prefix=../usr/bin/

	case $(get_alternative) in
		gnu)
			dosym gcpio /bin/cpio
			newman - cpio.1 <<<".so gcpio.1"
			;;
		libarchive)
			dosym "${usr_prefix}bsdcpio" /bin/cpio
			newman - cpio.1 <<<".so bsdcpio.1"
			;;
	esac
}
