# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python client for Docker"
HOMEPAGE="https://github.com/docker/docker-py"
SRC_URI="https://github.com/docker/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/requests-2.24.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/websocket-client-0.32.0[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/paramiko-2.4.2[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs \
	'dev-python/recommonmark' \
	'>=dev-python/sphinx-1.4.6'
distutils_enable_tests pytest

src_prepare() {
	# localhost has a better chance of being in /etc/hosts
	sed -e 's:socket[.]gethostname():"localhost":' \
		-i tests/unit/api_test.py || die

	distutils-r1_src_prepare
}

python_test() {
	epytest -vv tests/unit
}
