# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Checks PyPI validity of reStructuredText"
HOMEPAGE="
	https://github.com/twolfson/restructuredtext-lint/
	https://pypi.org/project/restructuredtext-lint/
"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

RDEPEND="
	>=dev-python/docutils-0.11[${PYTHON_USEDEP}]
	<dev-python/docutils-1.0[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
