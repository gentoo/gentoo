# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Drop-in replacement for the standard datetime class"
HOMEPAGE="
	https://pendulum.eustace.io/
	https://github.com/sdispater/pendulum/
	https://pypi.org/project/pendulum/
"
SRC_URI="
	https://github.com/sdispater/pendulum/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~s390 ~sparc x86"

DEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytzdata[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? (
		dev-python/Babel[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
