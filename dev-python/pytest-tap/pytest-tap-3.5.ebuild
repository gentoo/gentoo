# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Reporting plugin for pytest that outputs Test Anything Protocol (TAP) data"
HOMEPAGE="
	https://github.com/python-tap/pytest-tap
	https://pypi.org/project/pytest-tap/
"
# No tests in sdist
SRC_URI="https://github.com/python-tap/pytest-tap/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

RDEPEND="
	dev-python/pytest[${PYTHON_USEDEP}]
	>=dev-python/tap-py-3.2[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.5-hatchling-wheel.patch
)

EPYTEST_PLUGINS=( "${PN}" )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
distutils_enable_tests pytest
