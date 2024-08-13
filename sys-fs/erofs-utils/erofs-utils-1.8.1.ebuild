# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Userspace tools for EROFS"
HOMEPAGE="https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"

SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/xiang/${PN}.git/snapshot/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong"

IUSE="fuse libdeflate +lz4 +lzma selinux static-libs +threads +uuid +zlib +zstd"

RDEPEND="
	fuse? ( sys-fs/fuse:0 )
	lz4? ( app-arch/lz4:0= )
	lzma? ( >=app-arch/xz-utils-5.4.0:0= )
	selinux? ( sys-libs/libselinux:0= )
	uuid? ( sys-apps/util-linux )
	zlib? (
		libdeflate? ( app-arch/libdeflate:0= )
		!libdeflate? ( sys-libs/zlib:0= )
	)
	zstd? ( app-arch/zstd:0= )
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
		$(use_with libdeflate)
		$(use_enable lz4)
		$(use_enable lzma)
		$(use_with selinux)
		$(use_enable static-libs static-fuse)
		$(use_enable threads multithreading)
		$(use_with uuid)
		$(use_with zlib)
		$(use_with zstd libzstd)
		--without-qpl  # not packaged
	)

	econf "${myeconfargs[@]}"
}
