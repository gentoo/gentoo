# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/volatility/volatility-2.4.1.ebuild,v 1.2 2014/11/30 16:49:47 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Framework for analyzing volatile memory"
HOMEPAGE="http://www.volatilityfoundation.org/"
#2.4.1 not on mirrors yet
#SRC_URI="http://downloads.volatilityfoundation.org/releases/${PV}/${P}.tar.gz"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-libs/distorm64-3[${PYTHON_USEDEP}]
	dev-libs/libpcre
	dev-python/pycrypto[${PYTHON_USEDEP}]"

src_install() {
	distutils-r1_src_install
	mkdir "${D}/usr/share/${PN}"
	mv "${D}/usr/contrib/plugins" "${D}/usr/share/${PN}/"
	rmdir "${D}/usr/contrib"
	mv "${D}/usr/tools" "${D}/usr/share/${PN}/"
	dosym /usr/bin/vol.py /usr/bin/volatility
}
