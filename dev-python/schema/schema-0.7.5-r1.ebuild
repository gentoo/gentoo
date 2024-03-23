# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Simple data validation library"
HOMEPAGE="
	https://github.com/keleshev/schema/
	https://pypi.org/project/schema/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest

src_prepare() {
	# py2 leftover
	> requirements.txt || die
	distutils-r1_src_prepare
}
