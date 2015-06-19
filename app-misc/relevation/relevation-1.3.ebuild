# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/relevation/relevation-1.3.ebuild,v 1.1 2014/06/22 12:48:15 radhermit Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="a command-line searcher for the Revelation password manager"
HOMEPAGE="http://p.outlyer.net/relevation/"
SRC_URI="http://p.outlyer.net/${PN}/files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pycrypto[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

python_prepare_all() {
	# install extra scripts in proper doc dir
	sed -i "s#relevation/extra#${PF}/extra#" setup.py || die

	distutils-r1_python_prepare_all
}
