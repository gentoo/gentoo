# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5}} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Thin-wrapper around the mock package for easier use with py.test"
HOMEPAGE="https://github.com/pytest-dev/pytest-mock/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]
	python_targets_python2_7? (
		dev-python/mock[python_targets_python2_7]
	)
	python_targets_pypy? (
		dev-python/mock[python_targets_pypy]
	)"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	PYTHONPATH=${PWD}${PYTHONPATH:+:}${PYTHONPATH} \
		py.test test_pytest_mock.py || die
}
