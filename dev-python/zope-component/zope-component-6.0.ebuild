# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Zope Component Architecture"
HOMEPAGE="
	https://pypi.org/project/zope.component/
	https://github.com/zopefoundation/zope.component/
"

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
