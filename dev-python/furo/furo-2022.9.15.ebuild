# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# sphinx-theme-builder is completely unusable, as it requires pinning
# to a very-specific nodejs version number, and ofc loves fetching
# everything from the Internet

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Clean customisable Sphinx documentation theme"
HOMEPAGE="
	https://pypi.org/project/furo/
	https://github.com/pradyunsg/furo/
"
SRC_URI="
	https://files.pythonhosted.org/packages/py3/${PN::1}/${PN}/${P}-py3-none-any.whl
"
S=${WORKDIR}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/sphinx-basic-ng[${PYTHON_USEDEP}]
"

python_compile() {
	distutils_wheel_install "${BUILD_DIR}/install" \
		"${DISTDIR}/${P}-py3-none-any.whl"
}
