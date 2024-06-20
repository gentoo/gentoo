# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Reusable deprecation helpers for Python projects"
HOMEPAGE="
	https://github.com/beanbaginc/housekeeping/
	https://pypi.org/project/housekeeping/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/typing-extensions-4.4[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		>=dev-python/kgb-7.1.1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
