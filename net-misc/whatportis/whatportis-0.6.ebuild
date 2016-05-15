# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{3,4,5}} )

inherit distutils-r1 eutils

DESCRIPTION="A command to search port names and numbers"
HOMEPAGE="http://github.com/ncrocfer/whatportis http://pypi.python.org/pypi/whatportis"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-python/click-6.2[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7.2[${PYTHON_USEDEP}]
	>=dev-python/tinydb-3.1.2[${PYTHON_USEDEP}]
	>=dev-python/simplejson-3.8.1[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	"${EPYTHON}" test_${PN}.py || die
}

pkg_postinst() {
	optfeature "Run ${PN} as a Server" dev-python/flask
}
