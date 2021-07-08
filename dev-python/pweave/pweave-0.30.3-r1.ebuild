# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_PN="Pweave"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Scientific report generator and literate programming tool"
HOMEPAGE="http://mpastell.com/pweave/
		https://github.com/mpastell/Pweave"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

IUSE="examples"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/${P}-docs.patch"
	"${FILESDIR}/${P}-rm-online-tests.patch" )

RDEPEND="
	dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/jupyter_client[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/nbconvert[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
"

DEPEND="test? (
	dev-python/coverage[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/nose[${PYTHON_USEDEP}]
	dev-python/notebook[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
)"

distutils_enable_sphinx doc/source dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

python_install_all() {
	if use examples; then
		insinto /usr/share/${PN}
		doins -r doc/examples
	fi

	distutils-r1_python_install_all
}
