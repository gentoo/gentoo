# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Alternative regular expression module to replace re"
HOMEPAGE="
	https://bitbucket.org/mrabarnett/mrab-regex/
	https://pypi.org/project/regex/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE="doc"

PATCHES=(
	"${FILESDIR}/${PN}-2021.4.4-pypy3-fix-test_empty_array.patch"
	"${FILESDIR}/${PN}-2021.4.4-pypy3-fix-test_issue_18468.patch"
)

distutils_enable_tests unittest

python_install_all() {
	use doc && local HTML_DOCS=( docs/Features.html )
	local DOCS=( README.rst docs/*.rst )

	distutils-r1_python_install_all
}
