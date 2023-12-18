# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="A sphinx extension for creating panels in a grid layout"
HOMEPAGE="
	https://github.com/executablebooks/sphinx-panels/
	https://pypi.org/project/sphinx-panels/
"
SRC_URI="
	https://github.com/executablebooks/sphinx-panels/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-regressions[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# https://github.com/executablebooks/sphinx-panels/pull/84
	"${FILESDIR}/${P}-sphinx-7.patch"
)

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/sphinx-rtd-theme

src_prepare() {
	# unpin deps
	sed -i -e 's:,<[0-9.]*::' setup.py || die
	distutils-r1_src_prepare
}
