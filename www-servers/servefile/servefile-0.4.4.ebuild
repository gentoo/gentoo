# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Serve a single file via HTTP"
HOMEPAGE="http://seba-geek.de/stuff/servefile/"
SRC_URI="http://seba-geek.de/proj/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

RDEPEND="
	ssl? ( dev-python/pyopenssl )
	sys-apps/grep
	sys-apps/iproute2
	sys-apps/net-tools
	sys-apps/sed"

src_install() {
	distutils-r1_src_install

	dodoc ChangeLog
	doman ${PN}.1
}
