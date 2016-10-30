# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Python client for Docker"
HOMEPAGE="https://github.com/docker/docker-py"
SRC_URI="https://github.com/docker/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( >=dev-python/mkdocs-0.14.0[${PYTHON_USEDEP}] )
	test? (
		~dev-python/mock-1.0.1[${PYTHON_USEDEP}]
		~dev-python/pytest-2.7.2[${PYTHON_USEDEP}]
		~dev-python/pytest-cov-2.1.0[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	>=dev-python/docker-pycreds-0.2.1[${PYTHON_USEDEP}]
	!~dev-python/requests-2.11.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.5.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/websocket-client-0.32.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/backports-ssl-match-hostname-3.5[${PYTHON_USEDEP}]' 'python2_7' 'python3_3' 'python3_4' )
	$(python_gen_cond_dep '>=dev-python/ipaddress-1.0.16[${PYTHON_USEDEP}]' 'python2_7' )
"

python_compile_all() {
	if use doc; then
		mkdocs build -d 'mkdocs_site' || die "docs failed to build"
	fi
}

python_test() {
	py.test tests/unit/ | die "tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( mkdocs_site/. )

	distutils-r1_python_install_all
}
