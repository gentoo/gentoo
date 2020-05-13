# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="sphinx extension to support coroutines in markup"
HOMEPAGE="https://github.com/aio-libs/sphinxcontrib-asyncio"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="doc"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"
RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/namespace-sphinxcontrib[${PYTHON_USEDEP}]"

python_compile_all() {
	use doc && emake -C docs html
}

python_install() {
	rm "${BUILD_DIR}"/lib/sphinxcontrib/__init__.py || die
	distutils-r1_python_install --skip-build
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
	# clean up pth files bug #623852
	find "${ED}" -name '*.pth' -delete || die
}
