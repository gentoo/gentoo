# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="General purpose exceptions for Zope packages"
HOMEPAGE="
	https://pypi.org/project/zope.exceptions/
	https://github.com/zopefoundation/zope.exceptions/
"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND="
	dev-python/zope-interface[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

src_prepare() {
	distutils-r1_src_prepare

	# strip rdep specific to namespaces
	sed -i -e "/'setuptools'/d" setup.py || die
}

python_test() {
	distutils_write_namespace zope
	eunittest -s "${BUILD_DIR}/install$(python_get_sitedir)"
}
