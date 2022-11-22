# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="CPIO symlink"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Base/Alternatives"
SRC_URI=""
S=${WORKDIR}

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+gnu libarchive split-usr"
REQUIRED_USE="^^ ( gnu libarchive )"

RDEPEND="
	gnu? ( >=app-arch/cpio-2.13-r4 )
	libarchive? ( app-arch/libarchive )
	!<app-arch/cpio-2.13-r4
"

src_install() {
	local usr_prefix=
	use split-usr && usr_prefix=../usr/bin/

	if use gnu; then
		dosym gcpio /bin/cpio
		newman - cpio.1 <<<".so gcpio.1"
	elif use libarchive; then
		dosym "${usr_prefix}bsdcpio" /bin/cpio
		newman - cpio.1 <<<".so bsdcpio.1"
	else
		die "Invalid USE flag combination (broken REQUIRED_USE?)"
	fi
}
