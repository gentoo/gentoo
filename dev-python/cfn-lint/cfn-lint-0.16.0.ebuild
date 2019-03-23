# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="Validate CloudFormation yaml/json templates against the CloudFormation spec."
HOMEPAGE="https://pypi.org/project/cfn-lint/ https://github.com/aws-cloudformation/cfn-python-lint"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT-no-attribution"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/aws-sam-translator[${PYTHON_USEDEP}]
	dev-python/jsonpatch[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/pathlib2[${PYTHON_USEDEP}]' 'python2_7')
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/requests-2.15.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
