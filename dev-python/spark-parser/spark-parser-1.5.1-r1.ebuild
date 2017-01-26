# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} pypy)

inherit distutils-r1

MY_PN="spark_parser"

DESCRIPTION="An Early-Algorithm Context-free grammar Parser"
HOMEPAGE="https://github.com/rocky/python-spark/ https://pypi.python.org/pypi/spark_parser"
SRC_URI="mirror://pypi/${P:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/nose-1.0[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_PN}-${PV}"

python_test() {
	emake check
}
