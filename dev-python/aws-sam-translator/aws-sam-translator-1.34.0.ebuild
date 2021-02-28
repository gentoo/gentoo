# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend
inherit distutils-r1

DESCRIPTION="A library that transform SAM templates into AWS CloudFormation templates"
HOMEPAGE="https://github.com/aws/serverless-application-model
	https://pypi.org/project/aws-sam-translator/"
SRC_URI="https://github.com/aws/serverless-application-model/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/serverless-application-model-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/boto3-1.5[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.6[${PYTHON_USEDEP}]
	>=dev-python/six-1.11[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/parameterized[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# remove pytest-cov dependency
	sed -r -e 's:--cov(-[[:graph:]]+|)[[:space:]]+[[:graph:]]+::g' \
		-i pytest.ini || die

	# don't install tests
	sed -e 's:"tests",:"tests", "tests.*",:' -i setup.py || die

	# deps are installed by ebuild, don't try to reinstall them via pip
	truncate --size=0 requirements/*.txt || die

	distutils-r1_python_prepare_all
}
