# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN/-/.}
PYPI_VERIFY_REPO=https://github.com/zopefoundation/zope.deprecation
PYTHON_COMPAT=( python3_{12..15} python3_{14..15}t )

inherit distutils-r1 pypi

DESCRIPTION="Zope Deprecation Infrastructure"
HOMEPAGE="
	https://pypi.org/project/zope.deprecation/
	https://github.com/zopefoundation/zope.deprecation/
"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

distutils_enable_tests unittest

python_test() {
	distutils_write_namespace zope
	eunittest -s "${BUILD_DIR}/install$(python_get_sitedir)"
}
