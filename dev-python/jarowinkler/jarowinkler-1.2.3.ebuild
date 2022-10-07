# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# custom wrapper over setuptools
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Fast fuzzy string matching using Jaro and Jaro-Winkler similarity"
HOMEPAGE="
	https://github.com/maxbachmann/JaroWinkler/
	https://pypi.org/project/jarowinkler/
"
SRC_URI="
	mirror://pypi/${PN::1}/${PN}/${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

DEPEND="
	dev-cpp/jarowinkler-cpp
"
BDEPEND="
	dev-python/rapidfuzz_capi[${PYTHON_USEDEP}]
	>=dev-python/scikit-build-0.13.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

export JAROWINKLER_BUILD_EXTENSION=1
