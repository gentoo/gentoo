# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN/-/.}
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Interfaces for Python"
HOMEPAGE="
	https://github.com/zopefoundation/zope.interface/
	https://pypi.org/project/zope.interface/
"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="+native-extensions"

BDEPEND="
	test? (
		dev-python/zope-event[${PYTHON_USEDEP}]
		dev-python/zope-testing[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_prepare() {
	distutils-r1_src_prepare

	# strip rdep specific to namespaces
	sed -i -e "/'setuptools'/d" setup.py || die
	# force failure if extension build fails
	sed -i -e "/'build_ext':/d" setup.py || die
	if ! use native-extensions; then
		sed -i -e '/ext_modules=/d' setup.py || die
	fi
}

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_test() {
	local -x PURE_PYTHON=0
	if ! use native-extensions || [[ ${EPYTHON} == pypy3 ]]; then
		PURE_PYTHON=1
	fi

	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	distutils_write_namespace zope
	eunittest
}
