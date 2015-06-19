# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pystache/pystache-0.5.4.ebuild,v 1.3 2014/10/10 10:58:19 ago Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )
inherit distutils-r1

DESCRIPTION="Mustache for Python"
HOMEPAGE="http://github.com/defunkt/pystache"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	pushd "${BUILD_DIR}"/lib > /dev/null
	nosetests || die
	popd > /dev/null
}
