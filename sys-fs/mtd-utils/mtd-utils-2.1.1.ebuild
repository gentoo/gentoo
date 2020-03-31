# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils vcs-snapshot

if [[ ${PV} == "99999999" ]] ; then
	EGIT_REPO_URI="git://git.infradead.org/mtd-utils.git"

	inherit git-r3
	SRC_URI=""
	#KEYWORDS=""
else
	if [[ ${PV} == *.*.* ]] ; then
		MY_PV="${PV}-*"
		SRC_URI="http://git.infradead.org/mtd-utils.git/snapshot/v${PV}.tar.gz -> ${P}.tar.gz"
	else
		MY_PV="${PV}-02ae0aac87576d07202a62d11294ea55b56f450b"
		SRC_URI="mirror://gentoo/${PN}-snapshot-${MY_PV}.tar.xz"
	fi
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="MTD userspace tools (NFTL, JFFS2, NAND, FTL, UBI)"
HOMEPAGE="http://git.infradead.org/?p=mtd-utils.git;a=summary"

LICENSE="GPL-2"
SLOT="0"
IUSE="xattr +lzo +zlib zstd"

# We need libuuid
RDEPEND="!sys-fs/mtd
	>=sys-apps/util-linux-2.16
	lzo? ( dev-libs/lzo )
	zlib? ( sys-libs/zlib )
	zstd? ( app-arch/zstd )"
# ACL is only required for the <sys/acl.h> header file to build mkfs.jffs2
# And ACL brings in Attr as well.
DEPEND="${RDEPEND}
	xattr? ( sys-apps/acl )
	sys-devel/libtool"

src_prepare() {
	default
	./autogen.sh || die
}

src_configure() {
	econf \
		$(use_with xattr) \
		$(use_with lzo) \
		$(use_with zlib) \
		$(use_with zstd)
}

src_install() {
	default
	dodoc jffsX-utils/device_table.txt
	newdoc ubifs-utils/mkfs.ubifs/README README.mkfs.ubifs
	doman \
		jffsX-utils/mkfs.jffs2.1 \
		ubi-utils/ubinize.8
}
