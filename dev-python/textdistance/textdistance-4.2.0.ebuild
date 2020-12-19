# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="Compute distance between the two texts"
HOMEPAGE="https://github.com/life4/textdistance"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Too many strange failures
RESTRICT="test"

BDEPEND="test? (
	dev-python/abydos[${PYTHON_USEDEP}]
	dev-python/hypothesis[${PYTHON_USEDEP}]
	dev-python/isort[${PYTHON_USEDEP}]
	dev-python/jellyfish[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/python-levenshtein[${PYTHON_USEDEP}]
	dev-python/pyxDamerauLevenshtein[${PYTHON_USEDEP}]
)"

distutils_enable_tests --install pytest
