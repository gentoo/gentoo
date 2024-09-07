# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="IPython HTML widgets for Jupyter"
HOMEPAGE="
	https://ipython.org/
	https://pypi.org/project/widgetsnbextension/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc64 ~riscv x86 ~amd64-linux ~x86-linux"

BDEPEND="
	dev-python/jupyter-packaging[${PYTHON_USEDEP}]
"

src_install() {
	distutils-r1_src_install

	mv "${ED}/usr/etc" "${ED}/etc" || die
}
