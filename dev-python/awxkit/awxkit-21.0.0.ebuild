# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Command line interface for Ansible AWX"
HOMEPAGE="https://github.com/ansible/awx"
SRC_URI="https://github.com/ansible/awx/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/awx-${PV}/awxkit"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/websocket-client[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

	sed -e 's|websocket-client==[[:digit:]\.]*|websocket-client|' \
		-e "/'clean'/d" \
		-i setup.py || die
	distutils-r1_src_prepare
}
