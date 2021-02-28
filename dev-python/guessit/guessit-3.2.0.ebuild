# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Python library for guessing information from video filenames"
HOMEPAGE="https://github.com/guessit-io/guessit
	https://pypi.org/project/guessit/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

RDEPEND="
	>=dev-python/babelfish-0.5.5[${PYTHON_USEDEP}]
	>=dev-python/rebulk-3[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	# Disable benchmarks as they require unavailable pytest-benchmark.
	rm guessit/test/test_benchmark.py || die
	sed -i -e "s|'pytest-benchmark',||g" setup.py || die

	# Disable unconditional dependency on dev-python/pytest-runner.
	sed -i -e "s|'pytest-runner'||g" setup.py || die

	distutils-r1_python_prepare_all
}
