# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{11..14} python3_{13..14}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Zope support for i18nmessageid (tagging source of i18n strings)"
HOMEPAGE="
	https://pypi.org/project/zope.i18nmessageid/
	https://github.com/zopefoundation/zope.i18nmessageid/
"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

distutils_enable_tests unittest

src_prepare() {
	distutils-r1_src_prepare

	# force failure if extension build fails
	sed -i -e "s/cmdclass={.*},//" setup.py || die
}

python_test() {
	eunittest -s "${BUILD_DIR}/install$(python_get_sitedir)/zope"
}
