# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/stevedore/stevedore-1.3.0.ebuild,v 1.4 2015/07/08 20:52:24 zlogene Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="Manage dynamic plugins for Python applications"
HOMEPAGE="https://github.com/openstack/stevedore https://pypi.python.org/pypi/stevedore"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/pbr-0.8.0[${PYTHON_USEDEP}]
	<dev-python/pbr-1.0.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.2.0[${PYTHON_USEDEP}]
	)
	doc? (
		>=dev-python/pillow-2.4.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.2.0[${PYTHON_USEDEP}]
	)
"
RDEPEND=">=dev-python/six-1.9.0[${PYTHON_USEDEP}]"

python_compile_all() {
	use doc && ${EPYTHON} setup.py build_sphinx
}

python_test() {
	nosetests stevedore || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )

	distutils-r1_python_install_all
}
