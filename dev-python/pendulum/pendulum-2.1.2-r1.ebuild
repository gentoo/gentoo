# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Drop-in replacement for the standard datetime class"
HOMEPAGE="https://pendulum.eustace.io/ https://github.com/sdispater/pendulum"
SRC_URI="https://github.com/sdispater/pendulum/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

# Requires timezone information which is not installed by default
# with dev-python/pytzdata, and otherwise approx. 50 out of 1600
# tests are failing for now. Keeping the test dependencies
# commented for future tests fixups
RESTRICT="test"

DEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytzdata[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

#BDEPEND="
#	test? (
#		dev-python/babel[${PYTHON_USEDEP}]
#		dev-python/freezegun[${PYTHON_USEDEP}]
#		dev-python/pytz[${PYTHON_USEDEP}]
#	)"

# distutils_enable_tests pytest
