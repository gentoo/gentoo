# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="a rsync-based dump file system backup tool"
HOMEPAGE="https://github.com/leahneukirchen/rdumpfs"
SRC_URI="https://github.com/leahneukirchen/rdumpfs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+xattr"

RDEPEND="net-misc/rsync[xattr?]"

src_prepare() {
	default
	use xattr || sed -i '/RDUMPFS_DEFAULT_ARGS:=/s/aHAX/aHA/' "${PN}" || die
}

src_install() {
	dobin "${PN}"
	dodoc README
}
