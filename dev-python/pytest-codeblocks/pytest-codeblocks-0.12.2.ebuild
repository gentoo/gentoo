# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Extract code blocks from markdown"
HOMEPAGE="https://github.com/nschloe/pytest-codeblocks/"
SRC_URI="
	https://github.com/nschloe/pytest-codeblocks/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/pytest-6[${PYTHON_USEDEP}]"

distutils_enable_tests --install pytest

python_test() {
	distutils_install_for_testing
	epytest -p pytester
}
