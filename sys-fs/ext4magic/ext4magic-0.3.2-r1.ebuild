# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tool for recovery of deleted or overwritten files on ext3/ext4 filesystems"
HOMEPAGE="https://sourceforge.net/projects/ext4magic/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +expert-mode file-attr"

RDEPEND="app-arch/bzip2
	>=sys-apps/file-5.04
	sys-apps/util-linux
	>=sys-fs/e2fsprogs-1.41.9
	sys-libs/zlib"
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog NEWS README TODO"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.2-sysmacros.patch
	"${FILESDIR}"/${PN}-0.3.2-i_dir_acl.patch
)

src_configure() {
	# build-system incorrectly recognizes '--disable-feature' options as enabled!
	econf \
		$(usex debug '--enable-debug' '') \
		$(usex debug '--enable-debug-magic' '') \
		$(usex expert-mode '--enable-expert-mode' '') \
		$(usex file-attr '--enable-file-attr' '')
}
