# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Zope Component Architecture"
HOMEPAGE="
	https://pypi.org/project/zope.component/
	https://github.com/zopefoundation/zope.component/
"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-python/zope-event[${PYTHON_USEDEP}]
	>=dev-python/zope-hookable-4.2.0[${PYTHON_USEDEP}]
	>=dev-python/zope-interface-5.3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/zope-configuration[${PYTHON_USEDEP}]
		dev-python/zope-i18nmessageid[${PYTHON_USEDEP}]
		dev-python/zope-testing[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

python_test() {
	distutils_write_namespace zope
	eunittest -s "${BUILD_DIR}/install$(python_get_sitedir)"
}
