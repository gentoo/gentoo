# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/libeatmydata/libeatmydata-65.ebuild,v 1.1 2012/10/15 20:17:14 slyfox Exp $

EAPI="4"
inherit eutils

DESCRIPTION="LD_PRELOAD hack to convert sync()/msync() and the like to NO-OP"
HOMEPAGE="https://launchpad.net/libeatmydata/"
SRC_URI="https://launchpad.net/${PN}/trunk/release-${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

# sandbox fools LD_PRELOAD and libeatmydata does not get control
# bug/feature in sandbox?
#DEPEND="test? ( dev-util/strace )"
RESTRICT=test

DEPEND="sys-apps/sed"
RDEPEND=""

src_install() {
	default

	prune_libtool_files --all
	dodoc AUTHORS README
}
