# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

MY_PN=${PN/-/.}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Interfaces for Python"
HOMEPAGE="
	https://github.com/zopefoundation/zope.interface/
	https://pypi.org/project/zope.interface/
"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	!dev-python/namespace-zope
"
BDEPEND="
	test? (
		dev-python/zope-event[${PYTHON_USEDEP}]
		dev-python/zope-testing[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/5.1.0-drop-coverage.patch
)

distutils_enable_tests unittest

src_prepare() {
	# strip rdep specific to namespaces
	sed -e "/'setuptools'/d" -i setup.py || die
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
