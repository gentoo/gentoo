# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

MY_P="python-quantities-${PV}"
DESCRIPTION="Support for physical quantities with units, based on numpy"
HOMEPAGE="https://github.com/python-quantities/python-quantities"
SRC_URI="
	https://github.com/python-quantities/python-quantities/archive/v${PV}.tar.gz
		-> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/numpy[$PYTHON_USEDEP]
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-numpy-1.21.patch
)

EPYTEST_DESELECT=(
	# unexpected success
	quantities/tests/test_umath.py::TestUmath::test_fix
)
