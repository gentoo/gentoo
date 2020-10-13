# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_7,3_8,3_9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Commonly needed Python modules used by Python software developed at OSRF"
HOMEPAGE="https://github.com/osrf/osrf_pycommon"
SRC_URI="https://github.com/osrf/osrf_pycommon/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-python/mock[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND="
	test? (
		dev-python/flake8[${PYTHON_USEDEP}]
	)
"
PATCHES=( "${FILESDIR}/str.patch" )

distutils_enable_tests pytest
