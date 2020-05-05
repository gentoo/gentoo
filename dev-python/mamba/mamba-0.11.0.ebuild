# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Python test runner born under the banner of Behavior Driven Development"
HOMEPAGE="https://nestorsalceda.github.io/mamba"
SRC_URI="https://github.com/nestorsalceda/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		>=dev-python/doublex-expects-0.7.0_rc1[${PYTHON_USEDEP}]
		>=dev-python/expects-0.8.0_rc2[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	>=dev-python/clint-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/coverage-3.7.1[${PYTHON_USEDEP}]
	>=dev-python/watchdog-0.8.1[${PYTHON_USEDEP}]
"

python_install() {
	distutils-r1_python_install
	python_optimize
}

python_test() {
	"${EPYTHON}" -m mamba.cli || die "Tests failed under ${EPYTHON}"
}
