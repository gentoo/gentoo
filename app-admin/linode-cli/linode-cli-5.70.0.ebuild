# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/linode/linode-cli
inherit distutils-r1 shell-completion

OPENAPI_TAG=20261028

DESCRIPTION="Official command-line interface for interacting with the Linode API"
HOMEPAGE="https://github.com/linode/linode-cli https://www.linode.com/"
SRC_URI="
	https://github.com/linode/linode-cli/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/linode/linode-api-openapi/archive/release-${OPENAPI_TAG}.tar.gz
		-> linode-api-openapi-${OPENAPI_TAG}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/boto3-1.36[${PYTHON_USEDEP}]
	>=dev-python/linode-metadata-0.3[${PYTHON_USEDEP}]
	dev-python/openapi3[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pytimeparse[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	<dev-python/urllib3-3[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-mock requests-mock )
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# needs network
	tests/unit/test_plugin_kubeconfig.py::test_nonexisting_id
)

python_prepare_all() {
	# Remove tests that require networking and a valid linode api key
	rm -r tests/integration || die

	distutils-r1_python_prepare_all
}

# We need to build the data-3 file from the openapi spec
python_configure_all() {
	sed "s/python3 /${EPYTHON} /" -i Makefile || die
	emake create-version bake \
		SPEC="${WORKDIR}"/linode-api-openapi-release-${OPENAPI_TAG}/openapi.json \
		LINODE_CLI_VERSION=${PV}
}

python_test() {
	# LINODE_CLI_TOKEN needs to be defined for the tests to run; define it to something invalid
	# and skip the tests that require it
	LINODE_CLI_TOKEN=invalid epytest
}

python_install_all() {
	distutils-r1_python_install_all

	PYTHONPATH=. ${EPYTHON} linodecli completion bash > "${T}/${PN}".bash || die
	PYTHONPATH=. ${EPYTHON} linodecli completion fish > "${T}/${PN}".fish || die

	newbashcomp "${T}/${PN}".bash ${PN}
	dofishcomp "${T}/${PN}".fish

	dosym ${PN} "$(get_bashcompdir)"/linode
	dosym ${PN} "$(get_bashcompdir)"/lin
	dosym ${PN}.fish "$(get_fishcompdir)"/linode.fish
	dosym ${PN}.fish "$(get_fishcompdir)"/lin.fish
}
