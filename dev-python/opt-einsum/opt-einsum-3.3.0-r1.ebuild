# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Optimized Einsum: A tensor contraction order optimizer"
HOMEPAGE="
	https://github.com/dgasmith/opt_einsum/
	https://pypi.org/project/opt-einsum/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/versioneer[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	# ancient, broken version
	rm versioneer.py || die
	distutils-r1_src_prepare
}
