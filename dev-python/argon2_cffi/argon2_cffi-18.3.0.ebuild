# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{4,5,6,7}} pypy pypy3 )
inherit distutils-r1

DESCRIPTION="CFFI bindings to the Argon2 password hashing library"
HOMEPAGE="https://github.com/hynek/argon2_cffi"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

COMMON_DEPEND="
	~app-crypt/argon2-20171227:=
	dev-python/six[${PYTHON_USEDEP}]
	virtual/python-cffi[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.0[${PYTHON_USEDEP}]
	)
"

DOCS=( AUTHORS.rst CHANGELOG.rst FAQ.rst README.rst )

python_configure_all() {
	export ARGON2_CFFI_USE_SYSTEM=1
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	pytest -vv || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
