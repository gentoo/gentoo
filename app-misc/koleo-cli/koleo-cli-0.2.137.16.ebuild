# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

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
	>=dev-python/rich-13.7[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32[${PYTHON_USEDEP}]
"

distutils_enable_tests import-check

src_prepare() {
	distutils-r1_src_prepare

	# unpin deps
	sed -i -e 's:~=:>=:' requirements.txt || die
}
