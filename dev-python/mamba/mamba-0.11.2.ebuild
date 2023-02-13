# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="Python test runner born under the banner of Behavior Driven Development"
HOMEPAGE="https://nestorsalceda.com/mamba/"
SRC_URI="https://github.com/nestorsalceda/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/clint-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/coverage-3.7.1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		>=dev-python/doublex-expects-0.7.0_rc1[${PYTHON_USEDEP}]
		>=dev-python/expects-0.8.0_rc2[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs --no-autodoc

python_test() {
	"${EPYTHON}" -m mamba.cli || die "Tests failed under ${EPYTHON}"
}
