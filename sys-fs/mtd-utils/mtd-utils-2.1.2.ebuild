# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="MTD userspace tools (NFTL, JFFS2, NAND, FTL, UBI)"
HOMEPAGE="http://git.infradead.org/?p=mtd-utils.git;a=summary"
SRC_URI="https://github.com/sigma-star/mtd-utils/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~mips ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="+lzo xattr +zstd"

DEPEND="!sys-fs/mtd
	>=sys-apps/util-linux-2.16
	sys-libs/zlib
	lzo? ( dev-libs/lzo )
	xattr? ( sys-apps/acl )
	zstd? ( app-arch/zstd )"
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/libtool"

DOCS=( jffsX-utils/device_table.txt ubifs-utils/mkfs.ubifs/README )

src_prepare() {
	default
	./autogen.sh || die
}

src_configure() {
	econf \
		$(use_with lzo) \
		$(use_with xattr) \
		$(use_with zstd)
}

src_install() {
	default
	doman \
		jffsX-utils/mkfs.jffs2.1 \
		ubi-utils/ubinize.8
}
