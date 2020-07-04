# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

MY_PN=${PN%-python}
MY_P=${MY_PN}-${PV}
DESCRIPTION="AWS X-Ray SDK for Python"
HOMEPAGE="https://github.com/aws/aws-xray-sdk-python https://pypi.org/project/aws-xray-sdk/"
SRC_URI="mirror://pypi/${P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""
RDEPEND=">=dev-python/botocore-1.12.122[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/jsonpickle[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
RESTRICT="test"
S=${WORKDIR}/${MY_P}

python_test() {
	esetup.py test || die "tests failed with ${EPYTHON}"
}
