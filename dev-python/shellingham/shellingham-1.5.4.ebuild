# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Tool to Detect Surrounding Shell"
HOMEPAGE="
	https://github.com/sarugaku/shellingham/
	https://pypi.org/project/shellingham/
"
# Missing tests in PYPI distribution so we use the GH package
SRC_URI="
	https://github.com/sarugaku/shellingham/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv"

DEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
