# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	"gnu:>=app-arch/tar-1.34-r2"
	libarchive:app-arch/libarchive
)

inherit app-alternatives

DESCRIPTION="Tar symlink"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="split-usr"

RDEPEND="
	!<app-arch/tar-1.34-r2
"

src_install() {
	local usr_prefix=
	use split-usr && usr_prefix=../usr/bin/

	case $(get_alternative) in
		gnu)
			dosym gtar /bin/tar
			newman - tar.1 <<<".so gtar.1"
			;;
		libarchive)
			dosym "${usr_prefix}bsdtar" /bin/tar
			newman - tar.1 <<<".so bsdtar.1"
			;;
	esac
}
