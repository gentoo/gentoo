# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy )

inherit distutils-r1

MY_PN="PyScaffold"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tool for easily putting up the scaffold of a Python project"
HOMEPAGE="https://pypi.python.org/pypi/PyScaffold http://pyscaffold.readthedocs.org/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	>=dev-python/pbr-1.6[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.7[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	sed \
		-e 's: + pytest_runner::g' \
		-i setup.py || die

	# Creates all sort of mem problem due to fetch restrictions
	rm tests/test_install.py || die

	# Online tests
	sed \
		-e 's:test_api_with_cookiecutter:_&:g' \
		-e 's:test_pyscaffold_keyword:_&:g' \
		-i tests/*py || die

	distutils-r1_python_prepare_all
}

python_test() {
	git config --global user.email "you@example.com"
	git config --global user.name "Your Name"

	TRAVIS=False py.test -v -v || die
}
