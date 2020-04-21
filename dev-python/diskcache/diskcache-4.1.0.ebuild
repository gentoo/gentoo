# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
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
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs
distutils_enable_tests pytest

src_prepare() {
	# remove dep on pytest-xdist
	sed -i -e '/-n auto/d' tox.ini || die
	# requires django-1.1*
	rm diskcache/djangocache.py || die
	sed -e '/diskcache\.djangocache/d' \
		-e 's:test_djangocache:_&:' \
		-i tests/test_doctest.py || die
	rm tests/test_djangocache.py || die

	distutils-r1_src_prepare
}

pkg_postinst() {
	elog "Please note that the Gentoo package does not install the djangocache"
	elog "submodule as it requires old version of dev-python/django."
}
