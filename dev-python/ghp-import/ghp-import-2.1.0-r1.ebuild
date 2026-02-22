# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Copy your docs directly to the gh-pages branch"
HOMEPAGE="
	https://github.com/c-w/ghp-import/
	https://pypi.org/project/ghp-import/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-python/python-dateutil-2.8.1[${PYTHON_USEDEP}]
"
