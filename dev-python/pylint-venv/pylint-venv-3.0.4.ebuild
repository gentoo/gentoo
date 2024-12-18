# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="Init-hook to use the same Pylint with different virtual environments"
HOMEPAGE="
	https://pypi.org/project/pylint-venv/
	https://github.com/jgosmann/pylint-venv/
"
SRC_URI="
	https://github.com/jgosmann/pylint-venv/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/pylint-2.14.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/pylint-2.14.0[${PYTHON_USEDEP}]
	)
"

python_test() {
	# we need to set PYTHONPATH explicitly since the test runs installed
	# pylint (i.e. starts outside the test venv)
	local -x PYTHONPATH=${S}:${PYTHONPATH}
	bash test/test.sh || die "Test failed with ${EPYTHON}"
}
