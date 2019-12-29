# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

DESCRIPTION="A Session and Caching library with WSGI Middleware"
HOMEPAGE="
	https://github.com/bbangert/beaker
	https://beaker.readthedocs.io/en/latest/
	https://pypi.org/project/Beaker/"
# pypi tarball lacks tests
SRC_URI="https://github.com/bbangert/beaker/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/python-funcsigs[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		$(python_gen_impl_dep sqlite)
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		|| (
			dev-python/pycryptodome[${PYTHON_USEDEP}]
			dev-python/pycrypto[${PYTHON_USEDEP}]
		)
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	# disarm pycrypto dep to allow || ( pycryptodome pycrypto )
	sed -i -e "/TEST/s:'pycrypto'::" setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
}

pkg_postinst() {
	elog "beaker also has optional support for packages"
	elog "pycrypto and pycryptopp"
}
