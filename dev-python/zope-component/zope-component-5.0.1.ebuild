# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

MY_PN=zope.component
MY_P=${MY_PN}-${PV}
DESCRIPTION="Zope Component Architecture"
HOMEPAGE="
	https://pypi.org/project/zope.component/
	https://github.com/zopefoundation/zope.component/
"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="ZPL"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

RDEPEND="
	dev-python/zope-event[${PYTHON_USEDEP}]
	>=dev-python/zope-hookable-4.2.0[${PYTHON_USEDEP}]
	>=dev-python/zope-interface-5.3.0[${PYTHON_USEDEP}]
	!dev-python/namespace-zope
"
BDEPEND="
	test? (
		dev-python/zope-configuration[${PYTHON_USEDEP}]
		dev-python/zope-i18nmessageid[${PYTHON_USEDEP}]
		dev-python/zope-testing[${PYTHON_USEDEP}]
	)
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
