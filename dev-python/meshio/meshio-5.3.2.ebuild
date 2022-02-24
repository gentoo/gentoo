# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Input/output for many mesh formats"
HOMEPAGE="https://github.com/nschloe/meshio"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="hdf5 netcdf"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	hdf5? ( dev-python/h5py[${PYTHON_USEDEP}] )
	netcdf? ( dev-python/netcdf4-python[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? ( dev-python/h5py[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
