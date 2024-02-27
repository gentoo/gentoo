# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Zope Deprecation Infrastructure"
HOMEPAGE="
	https://pypi.org/project/zope.deprecation/
	https://github.com/zopefoundation/zope.deprecation/
"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

RDEPEND="
	!dev-python/namespace-zope
"

distutils_enable_tests unittest

src_prepare() {
	# strip rdep specific to namespaces
	sed -i -e "s:'setuptools',::" setup.py || die
	distutils-r1_src_prepare
}

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_test() {
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	distutils_write_namespace zope
	eunittest
}
