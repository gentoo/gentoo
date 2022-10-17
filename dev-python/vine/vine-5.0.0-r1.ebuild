# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Python Promises"
HOMEPAGE="
	https://github.com/celery/vine/
	https://pypi.org/project/vine/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

distutils_enable_tests pytest

src_prepare() {
	# remove the dep on dead dev-python/case package
	sed -i -e 's:from case:from unittest.mock:' t/unit/*.py || die
	# also removed upstream
	rm t/unit/conftest.py || die

	distutils-r1_src_prepare
}
