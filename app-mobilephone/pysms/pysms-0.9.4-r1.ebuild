# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/pysms/pysms-0.9.4-r1.ebuild,v 1.1 2015/02/11 06:57:09 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Tool for sending text messages for various Swiss providers"
HOMEPAGE="http://sourceforge.net/projects/pysms/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/pygtk[${PYTHON_USEDEP}]"

python_prepare() {
	sed -e "s:0.9.1:0.9.4:" \
		-e "s/Application;Network/Network/" \
		-i data/pysms.desktop || die
	rm -f MANIFEST.in

	distutils-r1_python_prepare
}
