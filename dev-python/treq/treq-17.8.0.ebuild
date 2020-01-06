# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="A requests-like API built on top of twisted.web's Agent"
HOMEPAGE="https://github.com/twisted/treq https://pypi.org/project/treq/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/incremental[${PYTHON_USEDEP}]
"

RDEPEND="${COMMON_DEPEND}
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' python2_7)
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/twisted-16.4.0[crypt,${PYTHON_USEDEP}]
	>=dev-python/requests-2.1.0[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
"

DEPEND="${COMMON_DEPEND}
	doc? ( dev-python/sphinx
		${RDEPEND} )
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pyflakes[${PYTHON_USEDEP}]
		dev-python/pep8[${PYTHON_USEDEP}]
		dev-python/httpbin[${PYTHON_USEDEP}]
	)"

python_compile_all() {
	use doc && emake -C "${S}/docs" html
}

python_install_all() {
	use doc && dohtml -r "${S}/docs/_build/html/"*
	distutils-r1_python_install_all
}

test_instructions(){
	ewarn "The 'test' USE flag and FEATURE only ensures that the correct"
	ewarn "dependenciess are installed for this package."
	ewarn "Please run eg:"
	ewarn "$ python3.4 /usr/bin/trial treq"
	ewarn "as a user for each of the python versions it is installed to"
	ewarn "to correctly test this package."
}

python_test() {
	# Tests fail when run via emerge
	# they need proper network access
	test_instructions
}
