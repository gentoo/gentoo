# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi shell-completion

DESCRIPTION="Official command-line interface for interacting with the Linode API"
HOMEPAGE="https://github.com/linode/linode-cli https://www.linode.com/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

# Tests require network, a linode account and an API key.
# WARNING: tests will incur costs and will wipe the account.
RESTRICT="test"

RDEPEND="
	dev-python/boto3[${PYTHON_USEDEP}]
	>=dev-python/linode-metadata-0.3[${PYTHON_USEDEP}]
	dev-python/openapi3[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	<dev-python/urllib3-3[${PYTHON_USEDEP}]
"

python_install_all() {
	distutils-r1_python_install_all

	PYTHONPATH=. ${EPYTHON} linodecli completion bash > "${T}/${PN}".bash || die
	PYTHONPATH=. ${EPYTHON} linodecli completion fish > "${T}/${PN}".fish || die

	newbashcomp "${T}/${PN}".bash ${PN}
	newfishcomp "${T}/${PN}".fish ${PN}

	dosym ${PN} "$(get_bashcompdir)"/linode
	dosym ${PN} "$(get_bashcompdir)"/lin
	dosym ${PN} "$(get_fishcompdir)"/linode
	dosym ${PN} "$(get_fishcompdir)"/lin
}
