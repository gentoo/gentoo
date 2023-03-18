# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="Time-handling functionality from netcdf4-python"
HOMEPAGE="https://pypi.org/project/cftime/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

DEPEND=">=dev-python/numpy-1.13.4[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-python/cython-0.26.2[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_prepare_all() {
	# remove pytest-cov dep
	sed -e "/--cov/d" -i setup.cfg || die

	distutils-r1_python_prepare_all
}
