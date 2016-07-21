# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit cmake-utils

DESCRIPTION="Daemon controlling CPU speed and temperature"
HOMEPAGE="https://bitbucket.org/nelchael/ncpufreqd"
SRC_URI="https://dev.gentoo.org/~mgorny/dist/${P}.tar.xz"
LICENSE="ZLIB"

SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

DEPEND="virtual/logger
	app-arch/xz-utils"
RDEPEND="${DEPEND}"

src_install() {
	cmake-utils_src_install

	doinitd gentoo-init.d/ncpufreqd
	dodoc AUTHORS ChangeLog README
}
