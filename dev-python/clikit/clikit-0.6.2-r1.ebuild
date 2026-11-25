# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry-core
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Group of utilities to build beautiful and testable command line interfaces"
HOMEPAGE="
	https://github.com/sdispater/clikit/
	https://pypi.org/project/clikit/
"
SRC_URI="
	https://github.com/sdispater/clikit/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~x86"

RDEPEND="
	dev-python/pastel[${PYTHON_USEDEP}]
	dev-python/pylev[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/crashtest[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-mock )
distutils_enable_tests pytest

python_test() {
	local -x COLUMNS=80
	epytest
}
