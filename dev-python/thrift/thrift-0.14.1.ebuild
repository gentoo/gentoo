# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Python implementation of Thrift"
HOMEPAGE="https://pypi.org/project/thrift/ https://thrift.apache.org/"
SRC_URI="https://downloads.apache.org/${PN}/${PV}//${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${P}/lib/py"

python_install() {
	distutils-r1_python_install
	python_optimize
}
