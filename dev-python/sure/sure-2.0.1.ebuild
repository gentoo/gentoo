# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="idiomatic assertion toolkit with human-friendly failure messages"
HOMEPAGE="
	https://github.com/gabrielfalcao/sure/
	https://pypi.org/project/sure/
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# requires dev-python/nose
	tests/test_old_api.py
)

src_prepare() {
	sed -i -e 's:--cov=sure::' setup.cfg || die
	distutils-r1_src_prepare
}
