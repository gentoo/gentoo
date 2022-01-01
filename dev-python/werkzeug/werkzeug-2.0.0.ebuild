# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1

DESCRIPTION="Collection of various utilities for WSGI applications"
HOMEPAGE="
	https://werkzeug.palletsprojects.com/
	https://pypi.org/project/Werkzeug/
	https://github.com/pallets/werkzeug"
SRC_URI="
	https://github.com/pallets/werkzeug/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"

DEPEND="
	test? (
		dev-python/cryptography[${PYTHON_USEDEP}]
		!hppa? ( !ia64? (
			$(python_gen_cond_dep '
				dev-python/greenlet[${PYTHON_USEDEP}]
			' 'python*')
		) )
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/pytest-xprocess[${PYTHON_USEDEP}]
		dev-python/watchdog[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_test() {
	epytest -p no:httpbin tests
}
