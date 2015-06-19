# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/whdd/whdd-2.2.ebuild,v 1.1 2014/11/02 15:39:08 maksbotan Exp $

EAPI=4

inherit cmake-utils

DESCRIPTION="Diagnostic and recovery tool for block devices"
HOMEPAGE="http://github.com/krieger-od/whdd"
SRC_URI="http://github.com/krieger-od/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-util/dialog
	sys-libs/ncurses[unicode]"
RDEPEND="${DEPEND}
	sys-apps/smartmontools"

src_unpack() {
	default
	mv krieger-od-${PN}-* ${P}
	echo ${PV} > "${S}"/VERSION || die
}
