# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Format click help output nicely with rich"
HOMEPAGE="
	https://pypi.org/project/rich-click/
	https://github.com/ewels/rich-click/
"
SRC_URI="
	https://github.com/ewels/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

RDEPEND="
	>=dev-python/click-8[${PYTHON_USEDEP}]
	>=dev-python/rich-12[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		>=dev-python/packaging-25[${PYTHON_USEDEP}]
		>=dev-python/typer-0.15[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( inline-snapshot )
distutils_enable_tests pytest

python_test() {
	epytest -o addopts=
}
