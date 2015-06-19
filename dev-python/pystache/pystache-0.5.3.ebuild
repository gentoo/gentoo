# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pystache/pystache-0.5.3.ebuild,v 1.4 2015/04/08 08:05:22 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )
inherit distutils-r1

DESCRIPTION="Mustache for Python"
HOMEPAGE="http://github.com/defunkt/pystache"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	cd "${BUILD_DIR}"/lib
	nosetests || die
}
