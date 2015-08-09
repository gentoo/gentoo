# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="virtualenv-based automation of test activities"
HOMEPAGE="http://tox.testrun.org http://pypi.python.org/pypi/tox"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/virtualenv-1.11.2[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		>=dev-python/py-1.4.17[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( >=dev-python/pytest-2.3.5[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# Take out failing tests known to pass when run manually
	# # Run from ebuild interferes in subtle & mysterious ways, inducing these erroroneous fails
	sed -e 's:test_package_install_fails:_&:' -e 's:test_different_config_cwd:_&:' \
		-e 's:test_develop:_&:' -e 's:test_usedevelop:_&:' \
		-e 's:test_usedevelop_mixed:_&:' -e 's:test__test_usedevelop:_&:' \
		-e 's:test_env_VIRTUALENV_PYTHON:_&:' \
		-i tests/test_z_cmdline.py || die

	if use doc; then
		local PYTHON_DOC_ATOM=$(best_version --host-root dev-python/python-docs:2.7)
		local PYTHON_DOC_VERSION="${PYTHON_DOC_ATOM#dev-python/python-docs-}"
		local PYTHON_DOC="/usr/share/doc/python-docs-${PYTHON_DOC_VERSION}/html"
		local PYTHON_DOC_INVENTORY="${PYTHON_DOC}/objects.inv"
		sed -i "s|'http://docs.python.org/': None|'${PYTHON_DOC}': '${PYTHON_DOC_INVENTORY}'|" doc/conf.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	py.test tests || die "Testsuite failed under ${EPYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( "${S}"/doc/_build/html/. )
	distutils-r1_python_install_all
}
