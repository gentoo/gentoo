# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_5 )
inherit distutils-r1

DESCRIPTION="A requests-like API built on top of twisted.web's Agent"
HOMEPAGE="https://github.com/twisted/treq https://pypi.org/project/treq/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

COMMON_DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="${COMMON_DEPEND}
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.15.1[${PYTHON_USEDEP}]
	>=dev-python/twisted-16.0.0[crypt,${PYTHON_USEDEP}]
	>=dev-python/requests-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/service_identity-14.0.0[${PYTHON_USEDEP}]
	dev-python/incremental[${PYTHON_USEDEP}]"

DEPEND="${COMMON_DEPEND}
	doc? ( dev-python/sphinx
		${RDEPEND} )
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pyflakes[${PYTHON_USEDEP}]
		dev-python/pep8[${PYTHON_USEDEP}]
	)"

python_compile_all() {
	use doc && emake -C "${S}/docs" html
}

python_install_all() {
	use doc && dohtml -r "${S}/docs/_build/html/"*
	distutils-r1_python_install_all
}

python_test() {
	trial treq || die "Tests fail with ${EPYTHON}"
}
