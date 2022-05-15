# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Doing dirty (but extremely useful) things with equals"
HOMEPAGE="
	https://dirty-equals.helpmanual.io/
	https://github.com/samuelcolvin/dirty-equals/
	https://pypi.org/project/dirty-equals/
"
SRC_URI="
	https://github.com/samuelcolvin/dirty-equals/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-python/pytz-2021.3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x TZ=UTC
	epytest
}
