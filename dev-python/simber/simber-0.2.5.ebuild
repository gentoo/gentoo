# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Simple, minimal and powerful logging library for Python"
HOMEPAGE="https://simber.deepjyoti30.dev/"
SRC_URI="https://github.com/deepjyoti30/${PN}/archive/${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="dev-python/colorama[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_prepare() {
	sed -i '/ *python_requires/s|.*||' setup.py || die  # bug #893620

	distutils-r1_src_prepare
}
