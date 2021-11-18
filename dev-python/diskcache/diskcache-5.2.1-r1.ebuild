# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

HOMEPAGE="http://www.grantjenks.com/docs/diskcache/
	https://github.com/grantjenks/python-diskcache/"
DESCRIPTION="Disk and file backed cache"
SRC_URI="
	https://github.com/grantjenks/python-diskcache/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"
S=${WORKDIR}/python-diskcache-${PV}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

distutils_enable_sphinx docs
distutils_enable_tests pytest

src_prepare() {
	# remove dep on pytest-xdist and pytest-cov
	sed -i -e '/-n auto/d' -e '/--cov/d' tox.ini || die

	distutils-r1_src_prepare
}

python_test() {
	local ignore=(
		# django tests don't work with django-3.2, and django-3.1
		# doesn't work with py3.10
		tests/test_djangocache.py
		tests/test_doctest.py
		README.rst
	)
	epytest ${ignore[@]/#/--ignore }
}
