# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )
inherit distutils-r1

DESCRIPTION="AWS SAM Translator library, transform SAM templates into AWS CloudFormation..."
HOMEPAGE="https://pypi.org/project/aws-sam-translator/ https://github.com/awslabs/serverless-application-model"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/boto3[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' 'python2_7')
	dev-python/six[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
