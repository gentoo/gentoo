# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Thin-wrapper around the mock package for easier use with py.test"
HOMEPAGE="https://github.com/pytest-dev/pytest-mock/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE=""

RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]
	python_targets_python2_7? (
		>=dev-python/mock-2[python_targets_python2_7]
	)
	python_targets_pypy? (
		>=dev-python/mock-2[python_targets_pypy]
	)"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]"

src_prepare() {
	if has_version dev-python/mock; then
		# test fails when standalone mock is installed
		sed -e 's|^\(def \)\(test_standalone_mock(\)|\1_\2|' -i test_pytest_mock.py || die
	fi
	distutils-r1_src_prepare
}

python_test() {
	PYTHONPATH=${PWD}${PYTHONPATH:+:}${PYTHONPATH} \
		py.test test_pytest_mock.py || die
}
