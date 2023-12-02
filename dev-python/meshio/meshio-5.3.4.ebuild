# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Input/output for many mesh formats"
HOMEPAGE="
	https://github.com/nschloe/meshio/
	https://pypi.org/project/meshio/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="hdf5 netcdf"

RDEPEND="
	>=dev-python/numpy-1.20.0[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	hdf5? ( dev-python/h5py[${PYTHON_USEDEP}] )
	netcdf? ( dev-python/netcdf4[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? ( dev-python/h5py[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
