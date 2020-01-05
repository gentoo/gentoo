# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1 vcs-snapshot

MY_PV=${PV/_/}

DESCRIPTION="Expects matchers for Doublex test doubles assertions"
HOMEPAGE="https://github.com/jaimegildesagredo/doublex-expects"
SRC_URI="https://github.com/jaimegildesagredo/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/mamba[${PYTHON_USEDEP}] )
"
RDEPEND="
	dev-python/doublex[${PYTHON_USEDEP}]
	>=dev-python/expects-0.8.0_rc1[${PYTHON_USEDEP}]
"

python_test() {
	mamba || die "Tests failed under ${EPYTHON}"
}
