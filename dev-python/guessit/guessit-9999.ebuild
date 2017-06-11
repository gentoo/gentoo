# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1 git-r3

DESCRIPTION="Python library for guessing information from video filenames"
HOMEPAGE="https://github.com/guessit-io/guessit https://pypi.python.org/pypi/guessit"
EGIT_REPO_URI=( {https,git}://github.com/${PN}-io/${PN}.git )
EGIT_BRANCH="develop"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="
	>=dev-python/babelfish-0.5.5[${PYTHON_USEDEP}]
	>=dev-python/rebulk-0.9.0[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/pytest-2.7.3[${PYTHON_USEDEP}]
		dev-python/pytest-capturelog[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	# Disable benchmarks as they require unavailable pytest-benchmark.
	rm guessit/test/test_benchmark.py || die
	sed -i -e "s|'pytest-benchmark',||g" setup.py || die

	# Disable unconditional dependency on dev-python/pytest-runner.
	sed -i -e "s|'pytest-runner'||g" setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}
