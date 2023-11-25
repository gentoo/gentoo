# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Python Promises"
HOMEPAGE="
	https://github.com/celery/vine/
	https://pypi.org/project/vine/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

distutils_enable_tests pytest

src_prepare() {
	# remove the dep on dead dev-python/case package
	sed -i -e 's:from case:from unittest.mock:' t/unit/*.py || die
	# also removed upstream
	rm t/unit/conftest.py || die

	distutils-r1_src_prepare
}
