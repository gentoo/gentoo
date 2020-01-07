# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Sphinx websupport extension"
HOMEPAGE="http://www.sphinx-doc.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/sqlalchemy-0.9[${PYTHON_USEDEP}]
	>=dev-python/whoosh-2.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.5[${PYTHON_USEDEP}]
	dev-python/namespace-sphinxcontrib[${PYTHON_USEDEP}]"
# avoid circular dependency with sphinx
PDEPEND="
	>=dev-python/sphinx-1.5.3[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		${PDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}

src_test() {
	cd tests || die
	distutils-r1_src_test
}

python_test() {
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
