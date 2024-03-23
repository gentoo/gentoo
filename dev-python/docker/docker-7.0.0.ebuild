# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=docker-py-${PV}
DESCRIPTION="Python client for Docker"
HOMEPAGE="
	https://github.com/docker/docker-py/
	https://pypi.org/project/docker/
"
SRC_URI="
	https://github.com/docker/docker-py/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/packaging-14.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.26.0[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		>=dev-python/paramiko-2.4.3[${PYTHON_USEDEP}]
		>=dev-python/websocket-client-0.32.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs \
	'dev-python/myst-parser'
distutils_enable_tests pytest

src_prepare() {
	# localhost has a better chance of being in /etc/hosts
	sed -e 's:socket[.]gethostname():"localhost":' \
		-i tests/unit/api_test.py || die

	distutils-r1_src_prepare

	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
}

python_test() {
	epytest tests/unit
}
