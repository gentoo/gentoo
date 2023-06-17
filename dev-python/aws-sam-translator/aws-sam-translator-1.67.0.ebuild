# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

MY_P=serverless-application-model-${PV}
DESCRIPTION="A library that transform SAM templates into AWS CloudFormation templates"
HOMEPAGE="
	https://github.com/aws/serverless-application-model/
	https://pypi.org/project/aws-sam-translator/
"
SRC_URI="
	https://github.com/aws/serverless-application-model/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	<dev-python/boto3-2[${PYTHON_USEDEP}]
	>=dev-python/boto3-1.19.5[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.2[${PYTHON_USEDEP}]
	<dev-python/pydantic-2[${PYTHON_USEDEP}]
	>=dev-python/pydantic-1.8[${PYTHON_USEDEP}]
	<dev-python/typing-extensions-5[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.4[${PYTHON_USEDEP}]
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
	# so much noise...
	sed -i -e '/log_cli/d' pytest.ini || die

	# deps are installed by ebuild, don't try to reinstall them via pip
	truncate --size=0 requirements/*.txt || die

	distutils-r1_python_prepare_all
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x AWS_DEFAULT_REGION=us-east-1
	epytest -o addopts=
}
