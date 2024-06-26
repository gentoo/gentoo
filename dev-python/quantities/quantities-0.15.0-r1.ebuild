# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P="python-quantities-${PV}"
DESCRIPTION="Support for physical quantities with units, based on numpy"
HOMEPAGE="
	https://github.com/python-quantities/python-quantities/
	https://pypi.org/project/quantities/
"
SRC_URI="
	https://github.com/python-quantities/python-quantities/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

# >=dev-python/numpy-2 is not currently supported,
# see https://github.com/python-quantities/python-quantities/pull/232
RDEPEND="
	>=dev-python/numpy-1.20[$PYTHON_USEDEP]
	<dev-python/numpy-2[$PYTHON_USEDEP]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	epytest --pyargs quantities.tests
}
