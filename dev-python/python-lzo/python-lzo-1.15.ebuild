# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 prefix pypi

DESCRIPTION="Python interface to lzo"
HOMEPAGE="
	https://github.com/jd-boyd/python-lzo/
	https://pypi.org/project/python-lzo/
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86 ~amd64-linux ~x86-linux"

DEPEND="
	dev-libs/lzo:2
"
RDEPEND="
	${DEPEND}
"

distutils_enable_tests pytest

python_prepare_all() {
	hprefixify setup.py
	distutils-r1_python_prepare_all
}
