# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Expects matchers for Doublex test doubles assertions"
HOMEPAGE="
	https://github.com/jaimegildesagredo/doublex-expects/
	https://pypi.org/project/doublex-expects/
"
SRC_URI="
	https://github.com/jaimegildesagredo/doublex-expects/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 arm64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/doublex[${PYTHON_USEDEP}]
	>=dev-python/expects-0.8.0_rc1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/mamba[${PYTHON_USEDEP}]
	)
"

python_test() {
	mamba || die "Tests failed under ${EPYTHON}"
}
