# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="Diagnostic and recovery tool for block devices"
HOMEPAGE="https://whdd.github.io"
SRC_URI="https://github.com/krieger-od/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-util/dialog
	sys-libs/ncurses:0[unicode]"
RDEPEND="${DEPEND}
	sys-apps/smartmontools"

src_unpack() {
	default
	mv krieger-od-${PN}-* ${P}
	echo ${PV} > "${S}"/VERSION || die
}
