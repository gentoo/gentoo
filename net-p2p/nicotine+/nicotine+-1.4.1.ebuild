# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="A fork of nicotine, a Soulseek client in Python"
HOMEPAGE="https://github.com/Nicotine-Plus/nicotine-plus"
SRC_URI="https://github.com/Nicotine-Plus/nicotine-plus/archive/1.4.1.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-python/pygtk-2.24[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}"

S="${WORKDIR}/nicotine-plus-${PV}"

pkg_postinst() {
	echo
	elog "You may want to install these packages to add additional features"
	elog "to Nicotine+:"
	elog
	elog "dev-python/geoip-python         Country lookup and flag display"
	elog "media-libs/mutagen              Media metadata extraction"
	elog "net-libs/miniupnpc              UPnP portmapping"
	echo
}
