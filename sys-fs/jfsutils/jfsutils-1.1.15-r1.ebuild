# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="IBM's Journaling Filesystem (JFS) Utilities"
HOMEPAGE="http://jfs.sourceforge.net/"
SRC_URI="http://jfs.sourceforge.net/project/pub/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 s390 ~sparc x86"
IUSE="static"

DOCS=( AUTHORS ChangeLog NEWS README )

PATCHES=(
	"${FILESDIR}"/${P}-linux-headers.patch #448844
	"${FILESDIR}"/${P}-sysmacros.patch #580056
	"${FILESDIR}"/${P}-check-for-ar.patch #726032
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	use static && append-ldflags -static
	econf --sbindir=/sbin
}

src_install() {
	default

	rm -f "${ED}"/sbin/{mkfs,fsck}.jfs || die
	dosym jfs_mkfs /sbin/mkfs.jfs
	dosym jfs_fsck /sbin/fsck.jfs
}
