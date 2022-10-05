# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="MTD userspace tools (NFTL, JFFS2, NAND, FTL, UBI)"
HOMEPAGE="https://git.infradead.org/?p=mtd-utils.git;a=summary"
SRC_URI="https://infraroot.at/pub/mtd/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 arm ~arm64 ~mips ppc ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="+lzo xattr +zstd"

DEPEND="
	sys-apps/util-linux:=
	sys-libs/zlib:=
	lzo? ( dev-libs/lzo:= )
	xattr? ( sys-apps/acl )
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}"

DOCS=( jffsX-utils/device_table.txt ubifs-utils/mkfs.ubifs/README )

PATCHES=(
	"${FILESDIR}"/${P}-glibc-2.36.patch
)

src_prepare() {
	default
	sed -i '/if test.*then/s: == : = :' configure || die
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
