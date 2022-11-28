# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Compute distance between the two texts"
HOMEPAGE="https://github.com/life4/textdistance"
SRC_URI="
	https://github.com/life4/textdistance/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~riscv x86"

BDEPEND="
	test? (
		dev-python/abydos[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/isort[${PYTHON_USEDEP}]
		dev-python/jellyfish[${PYTHON_USEDEP}]
		dev-python/Levenshtein[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pyxDamerauLevenshtein[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	tests/test_external.py
)
