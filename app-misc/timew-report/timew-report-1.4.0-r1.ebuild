# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="An interface for Timewarrior report data"
HOMEPAGE="
	https://github.com/lauft/timew-report/
	https://pypi.org/project/timew-report/
"
SRC_URI="
	https://github.com/lauft/timew-report/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-misc/timew
"
BDEPEND="
	dev-python/deprecation[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
