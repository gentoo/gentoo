# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Python library for guessing information from video filenames"
HOMEPAGE="
	https://github.com/guessit-io/guessit/
	https://pypi.org/project/guessit/
"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-python/babelfish-0.6.1[${PYTHON_USEDEP}]
	=dev-python/rebulk-6*[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.0[${PYTHON_USEDEP}]
"
# pyyaml is optional, keep it because we historically had it by default
RDEPEND+="
	dev-python/pyyaml[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-mock )
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# Disable benchmarks as they require unavailable pytest-benchmark.
	guessit/test/test_benchmark.py
)
