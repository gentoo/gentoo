# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Expressive and extensible TDD/BDD assertion library for Python"
HOMEPAGE="
	https://github.com/jaimegildesagredo/expects/
	https://pypi.org/project/expects/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 arm64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/mamba[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs

python_test() {
	mamba || die "tests failed under ${EPYTHON}"
}
