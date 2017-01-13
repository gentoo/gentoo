# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Python client for Docker"
HOMEPAGE="https://github.com/docker/docker-py"
SRC_URI="https://github.com/docker/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test" # doc

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.9.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-2.1.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.7.1[${PYTHON_USEDEP}]
	)
"
# Doc require later sphinx version that is not packaged yet
# doc? ( dev-python/recommonmark[${PYTHON_USEDEP}]
#	        >=dev-python/sphinx-1.4.6[${PYTHON_USEDEP}] )

RDEPEND="
	>=dev-python/docker-pycreds-0.2.1[${PYTHON_USEDEP}]
	!~dev-python/requests-2.12.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.11.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/websocket-client-0.32.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/backports-ssl-match-hostname-3.5[${PYTHON_USEDEP}]' 'python2_7' 'python3_4' )
	$(python_gen_cond_dep '>=dev-python/ipaddress-1.0.16[${PYTHON_USEDEP}]' 'python2_7' )
"

#python_compile_all() {
	#if use doc; then
	#	sphinx-build docs html || die "docs failed to build"
	#fi
#}

python_test() {
	py.test tests/unit/ || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	#use doc && local HTML_DOCS=( html/. )

	distutils-r1_python_install_all
}
