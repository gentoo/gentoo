# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="A Python implementation of the actor model"
HOMEPAGE="
	https://pykka.org/en/latest/
	https://github.com/jodal/pykka/
	https://pypi.org/project/pykka/
"
SRC_URI="
	https://github.com/jodal/pykka/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

EPYTEST_PLUGINS=( pytest-mock )
distutils_enable_tests pytest
