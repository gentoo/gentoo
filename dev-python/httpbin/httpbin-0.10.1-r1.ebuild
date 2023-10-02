# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="HTTP Request and Response Service"
HOMEPAGE="
	https://github.com/psf/httpbin/
	https://pypi.org/project/httpbin/
"

LICENSE="|| ( MIT ISC )"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/brotlicffi[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/flasgger[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	<dev-python/werkzeug-3[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-2.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
