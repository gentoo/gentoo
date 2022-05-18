# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

MY_PN=${PN/-/.}
MY_P=${MY_PN}-${PV}
DESCRIPTION="Zope Deprecation Infrastructure"
HOMEPAGE="
	https://pypi.org/project/zope.deprecation/
	https://github.com/zopefoundation/zope.deprecation/
"
SRC_URI="mirror://pypi/${MY_PN::1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	!dev-python/namespace-zope
"

distutils_enable_tests unittest

src_prepare() {
	# strip rdep specific to namespaces
	sed -i -e "/'setuptools'/d" setup.py || die
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
