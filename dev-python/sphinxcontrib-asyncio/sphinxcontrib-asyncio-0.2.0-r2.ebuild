# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="sphinx extension to support coroutines in markup"
HOMEPAGE="https://github.com/aio-libs/sphinxcontrib-asyncio"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-python/sphinx[${PYTHON_USEDEP}]
	dev-python/namespace-sphinxcontrib[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs

src_prepare() {
	# fix for sphinx >= 4.0
	sed -e 's/PyModulelevel/PyFunction/g' \
		-e 's/PyClassmember/PyClassMethod/g' \
		-i sphinxcontrib/asyncio.py || die
	default
}

python_install() {
	rm "${BUILD_DIR}"/lib/sphinxcontrib/__init__.py || die
	distutils-r1_python_install --skip-build
}

python_install_all() {
	distutils-r1_python_install_all
	# clean up pth files bug #623852
	find "${ED}" -name '*.pth' -delete || die
}
