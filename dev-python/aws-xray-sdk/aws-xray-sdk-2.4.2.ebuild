# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="The AWS X-Ray SDK for Python"
HOMEPAGE="https://pypi.org/project/aws-xray-sdk https://github.com/aws/aws-xray-sdk-python"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' 'python2_7')
	>=dev-python/setuptools-1.0[${PYTHON_USEDEP}]
	<dev-python/future-1.0.0[${PYTHON_USEDEP}]
	dev-python/jsonpickle[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
	>=dev-python/botocore-1.11.3[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
