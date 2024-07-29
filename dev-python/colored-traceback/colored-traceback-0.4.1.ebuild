# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Automatically color Python's uncaught exception tracebacks"
HOMEPAGE="
	https://github.com/staticshock/colored-traceback.py/
	https://pypi.org/project/colored-traceback/
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	dev-python/pygments[${PYTHON_USEDEP}]
"
