# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1

DESCRIPTION="Format click help output nicely with rich"
HOMEPAGE="
	https://pypi.org/project/rich-click/
	https://github.com/ewels/rich-click
"
SRC_URI="https://github.com/ewels/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

RDEPEND="
	>=dev-python/click-7[${PYTHON_USEDEP}]
	>=dev-python/rich-10.7[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( )

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	touch tests/fixtures/__init__.py || die
}
