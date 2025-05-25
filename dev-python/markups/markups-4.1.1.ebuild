# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="A wrapper around various text markups"
HOMEPAGE="
	https://pymarkups.readthedocs.io/en/latest/
	https://github.com/retext-project/pymarkups
	https://pypi.org/project/Markups/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

RDEPEND="
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/pymdown-extensions[${PYTHON_USEDEP}]
		dev-python/python-markdown-math[${PYTHON_USEDEP}]
		dev-python/textile[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
distutils_enable_sphinx docs
