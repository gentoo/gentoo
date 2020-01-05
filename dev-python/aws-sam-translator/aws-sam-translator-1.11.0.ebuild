# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A library that transform SAM templates into AWS CloudFormation templates"
HOMEPAGE="https://github.com/awslabs/serverless-application-model https://pypi.org/project/aws-sam-translator/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""
RDEPEND="virtual/python-enum34[${PYTHON_USEDEP}]
	>=dev-python/boto3-1.5[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.6[${PYTHON_USEDEP}]
	>=dev-python/six-1.11[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
RESTRICT="test"

python_test() {
	PYTHONPATH=${BUILD_DIR}/lib \
		esetup.py test || die "tests failed with ${EPYTHON}"
}
