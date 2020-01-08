# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit toolchain-funcs flag-o-matic

DESCRIPTION="DOS filesystem tools - provides mkdosfs, mkfs.msdos, mkfs.vfat"
HOMEPAGE="https://github.com/dosfstools/dosfstools"
SRC_URI="https://github.com/dosfstools/dosfstools/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="compat test +udev"
RESTRICT="!test? ( test )"

CDEPEND="udev? ( virtual/libudev )"
DEPEND="${CDEPEND}
	test? ( app-editors/vim-core )
	udev? ( virtual/pkgconfig )"
RDEPEND="${CDEPEND}"

src_configure() {
	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		$(use_enable compat compat-symlinks) \
		$(use_with udev)
}

src_install() {
	default
	if ! use compat; then
		# Keep fsck -t vfat and mkfs -t vfat working, bug 584980.
		dosym fsck.fat /usr/sbin/fsck.vfat
		dosym mkfs.fat /usr/sbin/mkfs.vfat
	fi
}
