# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vcs-snapshot

COMMIT="b7e8e7b0efd9d73344e022e204f2e99e6321136e"
DESCRIPTION="a rsync-based dump file system backup tool"
HOMEPAGE="https://github.com/chneukirchen/rdumpfs"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+xattr"

DEPEND=""
RDEPEND="net-misc/rsync[xattr?]"

src_prepare() {
	use xattr || sed -i '/RDUMPFS_DEFAULT_ARGS:=/s/aHAX/aHA/' "${PN}" || die
}

src_install() {
	dobin "${PN}"
	dodoc README
}
