# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="HTML parser based on the WHATWG HTML specification"
HOMEPAGE="
	https://doc.courtbouillon.org/tinyhtml5/latest/
	https://github.com/CourtBouillon/tinyhtml5/
	https://pypi.org/project/tinyhtml5/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/webencodings-0.5.1[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
