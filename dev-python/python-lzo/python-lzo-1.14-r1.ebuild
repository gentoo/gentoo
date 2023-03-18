# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 prefix pypi

DESCRIPTION="Python interface to lzo"
HOMEPAGE="https://github.com/jd-boyd/python-lzo"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~riscv x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-libs/lzo:2"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-pytest.patch
)

# We can't use pytest at the moment because the package uses "yield tests"
# https://docs.pytest.org/en/6.2.x/deprecations.html#yield-tests
distutils_enable_tests pytest

python_prepare_all() {
	hprefixify setup.py
	distutils-r1_python_prepare_all
}
