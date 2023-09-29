# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Userspace tools for EROFS"
HOMEPAGE="https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
LICENSE="GPL-2+"

SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/xiang/${PN}.git/snapshot/${P}.tar.gz"
KEYWORDS="~amd64 ~loong"

SLOT="0"
IUSE="fuse +lz4 +lzma selinux +uuid +zlib"

RDEPEND="
	fuse? ( sys-fs/fuse:0 )
	lz4? ( app-arch/lz4:0= )
	lzma? ( >=app-arch/xz-utils-5.4.0:0= )
	selinux? ( sys-libs/libselinux:0= )
	uuid? ( sys-apps/util-linux )
	zlib? ( sys-libs/zlib:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-werror
		$(use_enable fuse)
		$(use_enable lz4)
		$(use_enable lzma)
		$(use_with selinux)
		$(use_with uuid)
		$(use_with zlib)
		--without-libdeflate  # not packaged
	)

	econf "${myeconfargs[@]}"
}
