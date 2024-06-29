# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Generic floating-point types in Python"
HOMEPAGE="
	https://github.com/graphcore-research/gfloat/
	https://pypi.org/project/gfloat/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/ml-dtypes[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# requires mx (possibly git version), torch
	test/test_microxcaling.py
)
