# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="A simple CLI for koleo.pl railway planner"
HOMEPAGE="
	https://github.com/lzgirlcat/koleo-cli/
	https://pypi.org/project/koleo-cli/
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/aiohttp-3.2.13[${PYTHON_USEDEP}]
	>=dev-python/orjson-3.10.18[${PYTHON_USEDEP}]
	>=dev-python/rich-14.0.0[${PYTHON_USEDEP}]
"

distutils_enable_tests import-check

src_prepare() {
	distutils-r1_src_prepare

	# unpin deps
	sed -i -e 's:~=:>=:' requirements.txt || die
}
