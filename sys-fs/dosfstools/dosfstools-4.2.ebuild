# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="DOS filesystem tools - provides mkdosfs, mkfs.msdos, mkfs.vfat"
HOMEPAGE="https://github.com/dosfstools/dosfstools"
SRC_URI="https://github.com/dosfstools/dosfstools/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="compat +iconv test"
RESTRICT="!test? ( test )"

BDEPEND="
	iconv? ( virtual/libiconv )
	test? ( app-editors/vim-core )
"

src_configure() {
	local myeconfargs=(
		$(use_enable compat compat-symlinks)
		$(use_with iconv)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if ! use compat ; then
		# Keep fsck -t vfat and mkfs -t vfat working
		# bug #584980
		dosym fsck.fat /usr/sbin/fsck.vfat
		dosym mkfs.fat /usr/sbin/mkfs.vfat
	fi
}
