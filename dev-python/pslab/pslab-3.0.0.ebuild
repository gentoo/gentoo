# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=pslab-python-${PV}
DESCRIPTION="Python library for communicating with Pocket Science Lab"
HOMEPAGE="
	https://pslab.io/
	https://github.com/fossasia/pslab-python/
	https://pypi.org/project/pslab/
"
SRC_URI="
	https://github.com/fossasia/pslab-python/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=dev-python/mcbootflash-8.0.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.16.3[${PYTHON_USEDEP}]
	>=dev-python/pyserial-3.4[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.3.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.0-ad9833_sys_version.patch
	"${FILESDIR}"/${PN}-3.0.0-pytest_record.patch
)

EPYTEST_DESELECT=(
	# Flaky in 2.5.0
	tests/test_logic_analyzer.py::test_stop
)

distutils_enable_sphinx docs dev-python/recommonmark
distutils_enable_tests pytest
