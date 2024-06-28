# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Small library to dynamically create Python functions"
HOMEPAGE="
	https://pypi.org/project/makefun/
	https://github.com/smarie/python-makefun/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		# https://github.com/smarie/python-makefun/pull/103
		# https://github.com/smarie/python-makefun/pull/104
		"${FILESDIR}/${P}-test.patch"
	)

	distutils-r1_src_prepare

	sed -e '/pytest-runner/d' -i setup.cfg || die
}
