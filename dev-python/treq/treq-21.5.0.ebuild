# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A requests-like API built on top of twisted.web's Agent"
HOMEPAGE="https://github.com/twisted/treq https://pypi.org/project/treq/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-python/incremental[${PYTHON_USEDEP}]
	>=dev-python/hyperlink-21.0.0[${PYTHON_USEDEP}]
"

RDEPEND="${COMMON_DEPEND}
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/twisted-18.7.0[crypt,${PYTHON_USEDEP}]
	>=dev-python/requests-2.1.0[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
"

DEPEND="${COMMON_DEPEND}
	doc? ( dev-python/sphinx
		${RDEPEND} )
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/httpbin[${PYTHON_USEDEP}]
	)"

python_compile_all() {
	use doc && emake -C "${S}/docs" html
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/ )

	distutils-r1_python_install_all
}

python_test() {
	distutils_install_for_testing
	"${EPYTHON}" trial treq || die "Tests failed with ${EPYTHON}"
}
